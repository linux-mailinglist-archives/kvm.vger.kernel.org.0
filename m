Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8486F4EC
	for <lists+kvm@lfdr.de>; Sun, 21 Jul 2019 21:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbfGUTOP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Jul 2019 15:14:15 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:33666 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726946AbfGUTOP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Jul 2019 15:14:15 -0400
Received: by mail-wr1-f51.google.com with SMTP id n9so37190740wru.0
        for <kvm@vger.kernel.org>; Sun, 21 Jul 2019 12:14:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8c4DJTfhSg2W6KoSf+Qxaj24B9FivVRolxBUf34I1A4=;
        b=GT0EVx9ejuMhXl/BtrLs3T1QlndlaXcLeLBFaA4OOQUtiGVa0dswyOdp5eNtUYMYsn
         TCsHEo+ZTi0IaiO4CXuuhFilyr+z+XttMQ6OAenilH7l2rWqRLBwZPtuVEDJe4ceNa8o
         Ug2Wr1WkhNYGkmOIsbw9r1wIRfPyaEQbYzsSjNTn00Owh8E3hVT64ntk99gZW7iytxia
         /Rti8bu/zIsuVusYGSsjYvpFVSs2pKl6osU3zvGrRtel/GA0V0/zruLrs5SFSJa4OGm4
         pRsbhxHTtzTUQq9SJmsvxFq4Nedm5r8KnBw8fvBVB7St1mg5mh8HrYhX3bipWcpiNviz
         rLKQ==
X-Gm-Message-State: APjAAAWoam551ReUQvb+JvLO6XE72inWtMMTOYSSlFtOHsl5jtcx95P+
        Xrow8H9TvISygHgJIb9Ais71qA==
X-Google-Smtp-Source: APXvYqw8cLUk/79FWV524hjEPaZnlwTw0ykVQbH9waqyrQMZU6w/Eb0X+2Ew5CgF/VEH6geHNZ2fvA==
X-Received: by 2002:a5d:62cc:: with SMTP id o12mr13779208wrv.63.1563736453010;
        Sun, 21 Jul 2019 12:14:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f5ce:1d64:8195:e39d? ([2001:b07:6468:f312:f5ce:1d64:8195:e39d])
        by smtp.gmail.com with ESMTPSA id v124sm39039546wmf.23.2019.07.21.12.14.11
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Jul 2019 12:14:11 -0700 (PDT)
Subject: Re: nvmx: get/set_nested_state ignores VM_EXIT_INSTRUCTION_LEN
To:     Jan Kiszka <jan.kiszka@web.de>, Liran Alon <liran.alon@oracle.com>,
        kvm <kvm@vger.kernel.org>
Cc:     Jim Mattson <jmattson@google.com>,
        KarimAllah Ahmed <karahmed@amazon.de>
References: <3299adf3-3979-7718-702f-bab2d9324c69@web.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5bfb611e-f136-d9e4-7888-123d21e738c2@redhat.com>
Date:   Sun, 21 Jul 2019 21:14:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <3299adf3-3979-7718-702f-bab2d9324c69@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/07/19 19:40, Jan Kiszka wrote:
> Hi all,
> 
> made some progress understanding why vmport from L2 breaks since QEMU gets/sets
> the nested state around it: We do not preserve VM_EXIT_INSTRUCTION_LEN, and that
> breaks skip_emulated_instruction when completing the PIO access on next run. The
> field is suddenly 0, and so we loop infinitely over the IO instruction. Unless
> some other magic prevents migration while an IO instruction is in flight, vmport
> may not be the only victim here.
> 
> Now the question is how to preserve that information: Can we restore the value
> into vmcs02 on set_nested_state, despite this field being read-only? Or do we
> need to cache its content and use that instead in skip_emulated_instruction?

Hmm I think technically this is invalid, since you're not supposed to
modify state at all while MMIO is pending.  Of course that's kinda moot
if it's the only way to emulate vmport, but perhaps we can (or even
should!) fix it in QEMU.  Is KVM_SET_NESTED_STATE needed for level <
KVM_PUT_RESET_STATE?  Even if it is, we should first complete I/O and
then do kvm_arch_put_registers.

> Looking at this pattern, I wonder if there is more. What other fields are used
> across PIO or MMIO when the handling is done by userland?

