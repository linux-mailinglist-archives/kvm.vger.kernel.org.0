Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D055956781
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 13:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727284AbfFZLXE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 07:23:04 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46755 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbfFZLXE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 07:23:04 -0400
Received: by mail-wr1-f65.google.com with SMTP id n4so2247088wrw.13
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2019 04:23:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fjQc1qNIdZfNF/NDujWvCMQ2yfBiCYxY24N/zNlf1Sc=;
        b=KW4TxL0Z+DVucJL6G6gklImu93yZqOWmkT8T+nq8ev416DLa6uIWoIcc+gQOEasbZR
         PlwyKEmZzDNNRDeQmU4OBMQSKsoCA22j1mzoCHF91RtarqTHZdABD6qYwVctju+VE7yt
         Lkcpd1UrMbwSRx1zTISrY9prGz4RL9Zx2And8Q9wf1ak9T+Vct5RzJyTp1X/MpH4Y2Td
         eH6TCJg4EUusFWo5ZTMGK2uYc9VmcHnu+c3PmpoZbVR8fjjrJs2LY/JXXChv3yfE97Z1
         WH6bO/dwEIXaDtECPDaGB9jwXD/r6gDiaGXhjhKkg4rWv0ffZ0kmVoOwIqfng2nh/dcH
         fFIw==
X-Gm-Message-State: APjAAAVIqlab9TdvKbik6v2fGIBKS7hXQOTVDLNYSZdRXSHiRqE/HT//
        0YPDPb98PCne920WBvlQfBrupQ==
X-Google-Smtp-Source: APXvYqxzPVbgC2v5Z5f684Hw679jGU5eIVWc5gw7gHAtuDitqWREZ2c9Yv7LwO07wFwWn8EJzrI8QQ==
X-Received: by 2002:adf:c654:: with SMTP id u20mr3435135wrg.271.1561548182090;
        Wed, 26 Jun 2019 04:23:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:61c1:6d8f:e2c4:2d5c? ([2001:b07:6468:f312:61c1:6d8f:e2c4:2d5c])
        by smtp.gmail.com with ESMTPSA id a7sm17956545wrs.94.2019.06.26.04.23.00
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 04:23:01 -0700 (PDT)
Subject: Re: [PATCH 1/1] kvm/speculation: Allow KVM guests to use SSBD even if
 host does not
To:     Thomas Gleixner <tglx@linutronix.de>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc:     mingo@redhat.com, Borislav Petkov <bp@alien8.de>,
        rkrcmar@redhat.com, x86@kernel.org, kvm@vger.kernel.org,
        stable <stable@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Jon Masters <jcm@redhat.com>
References: <1560187210-11054-1-git-send-email-alejandro.j.jimenez@oracle.com>
 <1c9d4047-e54c-8d4b-13b1-020864f2f5bf@redhat.com>
 <alpine.DEB.2.21.1906251750140.32342@nanos.tec.linutronix.de>
 <56fa2729-52a7-3994-5f7c-bc308da7d710@oracle.com>
 <alpine.DEB.2.21.1906252019460.32342@nanos.tec.linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b6c2ac14-d647-0fa2-f19d-88944c63c37a@redhat.com>
Date:   Wed, 26 Jun 2019 13:23:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1906252019460.32342@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/06/19 20:22, Thomas Gleixner wrote:
>> I think that even with that approach there is still an unsolved problem, as I
>> believe guests are allowed to write directly to SPEC_CTRL MSR without causing
>> a VMEXIT, which bypasses the host masking entirely.  e.g. a guest using IBRS
>> writes frequently to SPEC_CTRL, and could turn off SSBD on the VPCU while is
>> running after the first non-zero write to the MSR. Do you agree?
> Indeed. Of course that was a decision we made _before_ all the other fancy
> things came around. Looks like we have to reopen that discussion.

It's not just that, it's a decision that was made because otherwise
performance is absolutely horrible (like 4-5x slower syscalls if the
guest is using IBRS).

I think it's better to leave the guest in control of SSBD even if it's
globally disabled.  The harm cannot escape the guest and in particular
it cannot escape to the sibling hyperthread.

Paolo
