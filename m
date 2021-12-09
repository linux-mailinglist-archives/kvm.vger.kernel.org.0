Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 109E946F275
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 18:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241380AbhLIRxe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 12:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234197AbhLIRxd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 12:53:33 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77B9C061746;
        Thu,  9 Dec 2021 09:49:59 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id x15so22574368edv.1;
        Thu, 09 Dec 2021 09:49:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=b2/w3Mux17JVdswuS8GICSIHr00q6jNMhNdTzH/Vkto=;
        b=ZgUIpRKw9jjsXGEiZB+eUI2F2CkqKetRDDUL9n9xn5GrC/H4yGvMqCqmgbajTChgDk
         Fk/GiGw0nftftK+0uwn8jqh1JlsIo+yEtPSDeD8MCSU4pFyNcFdwTStSgPN1O8oRBuH5
         HBG3vEY1yuRKFt7uvs9GKZuZnikVW4YphUtSSu5wHvLnHabps/kSoogHYDEcZHHFwy9g
         20SeadQptwrtVYRThqVFzcZy6mYHdC73krRvrKTF5m8vnC96DSu7uPRCOeGQoJS8UD6B
         v0bR1EjX66ij2iG1KwMF1WEPnJPufEhPbUWSpoOGthu8+Dkr3IqwoTXZcMypn/vPnvnb
         s7mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=b2/w3Mux17JVdswuS8GICSIHr00q6jNMhNdTzH/Vkto=;
        b=NOtw6z4eTsUyRD5a5JuMXxwOt8C7giauopLcOKPdsl5MPMNSvMPyzOmsW2ghte6Kfc
         TmWDsH5DUZ7JQIoG0Jv74hOUrbAIShabt9ccDAmUqvseX3qfibBptQPz21UjBJlD5Amc
         nRnO496sKR71Rbpjo9n2j5u7oTTOmB67v3OeubJ1f4WwtCKrB97Y7FMSqDpJ5eI/lASC
         cMSMDGxWd6uhsvRg3A95ShMafr/MNZAQYHoRTvf2KpJ5qL6rpSD5lX7ryzupEqRynzDn
         fNp2jMzpcLROdOp3r95qdAzejFSNsCRy/gc9wZ7K7QaiYk4oGsRCjsb4ZTIGwbicQ91h
         xMzg==
X-Gm-Message-State: AOAM5317R4EGeVAsnKWBSALt+vgfE2LDRx2ggjMFnyHpr68EPwtATeUb
        +SEZLrEYeLj6wqJDZ2xabxQ=
X-Google-Smtp-Source: ABdhPJzIj57JYsEUXST9cXT1SKx8xJD1bm8MZ/+NIQXJL83DlVbWwlryjlJtXUPw9zletHXHSanFeQ==
X-Received: by 2002:aa7:c9ce:: with SMTP id i14mr30422808edt.300.1639072103950;
        Thu, 09 Dec 2021 09:48:23 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id lv19sm240316ejb.54.2021.12.09.09.48.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 09:48:23 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <5f8c31b4-6223-a965-0e91-15b4ffc0335e@redhat.com>
Date:   Thu, 9 Dec 2021 18:48:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2] KVM: x86: Always set kvm_run->if_flag
Content-Language: en-US
To:     Marc Orr <marcorr@google.com>, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, thomas.lendacky@amd.com, mlevitsk@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211209155257.128747-1-marcorr@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211209155257.128747-1-marcorr@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/21 16:52, Marc Orr wrote:
> The kvm_run struct's if_flag is a part of the userspace/kernel API. The
> SEV-ES patches failed to set this flag because it's no longer needed by
> QEMU (according to the comment in the source code). However, other
> hypervisors may make use of this flag. Therefore, set the flag for
> guests with encrypted registers (i.e., with guest_state_protected set).
> 
> Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
> Signed-off-by: Marc Orr<marcorr@google.com>

Applied, though I wonder if it is really needed by those other VMMs 
(which? gVisor is the only one that comes to mind that is interested in 
userspace APIC).

It shouldn't be necessary for in-kernel APIC (where userspace can inject 
interrupts at any time), and ready_for_interrupt_injection is superior 
for userspace APIC.

Paolo
