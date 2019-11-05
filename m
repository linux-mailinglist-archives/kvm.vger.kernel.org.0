Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA753F0A72
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 00:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730537AbfKEXvg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 18:51:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57410 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730207AbfKEXvf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 18:51:35 -0500
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 567AB8553D
        for <kvm@vger.kernel.org>; Tue,  5 Nov 2019 23:51:35 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id l184so406468wmf.6
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2019 15:51:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gaWZ92U9HKAb67fEM4jNLU/s4Li1fTnEeskJpsm2ZGg=;
        b=hyz6bwYiKN5eQngjHTsnhV0w0jBF82O//xD7UfXi+hGfbEp6KdGOUSsuXfAFPZdwyI
         zqOzgUpSmJmmeB9htQRB8qIRaZi7n/m64ujWSZZYh9lwQIhyZ1DiTvjfyJLmqGqs5oNl
         VydKUk9kIFizgKZiYnJDHpY7t/lO+c6Kfhh3sVY77S9oviCLjatpFN247+8uzri+hDTC
         rC5kPfDgmJOvnh0byICr/VKOE2lyw+XKXE8N4BKMfPLcy/3zKtAYCfeuNKPABPAQOeRy
         QC4JTQIB5uIYvaTWG3cbU967Fjvg58Jw/Hko/R1CZqfg9uOE53SvbG2JWBaChlgAG88b
         2Vlw==
X-Gm-Message-State: APjAAAWA33HsSjN2ReP5y+UYGe1UMlTx4tXOwZQ/P9WT+27QlBxKiPXY
        hQvcVvRzgeLjH1CUEIIrbMWTWkwhONqLewxUvYOHfEF5n+z9LOo2TzEPbqeh8EoN+3OaPi86aQ0
        W1VUyGPisvP0I
X-Received: by 2002:a5d:6181:: with SMTP id j1mr267419wru.251.1572997893905;
        Tue, 05 Nov 2019 15:51:33 -0800 (PST)
X-Google-Smtp-Source: APXvYqzDqY7w8R9dweqYLGkk2vCiodr/pRCJoOl/ZjfV26tQ6Tyj4r7EE24VDAT05CYujBkslWIoTA==
X-Received: by 2002:a5d:6181:: with SMTP id j1mr267401wru.251.1572997893599;
        Tue, 05 Nov 2019 15:51:33 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id t24sm33590122wra.55.2019.11.05.15.51.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2019 15:51:33 -0800 (PST)
Subject: Re: [PATCH RFC] KVM: x86: tell guests if the exposed SMT topology is
 trustworthy
To:     Peter Zijlstra <peterz@infradead.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20191105161737.21395-1-vkuznets@redhat.com>
 <20191105200218.GF3079@worktop.programming.kicks-ass.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <51c9fe0c-0bda-978c-27f7-85fe7e59e91d@redhat.com>
Date:   Wed, 6 Nov 2019 00:51:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191105200218.GF3079@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/11/19 21:02, Peter Zijlstra wrote:
> On Tue, Nov 05, 2019 at 05:17:37PM +0100, Vitaly Kuznetsov wrote:
>> Virtualized guests may pick a different strategy to mitigate hardware
>> vulnerabilities when it comes to hyper-threading: disable SMT completely,
>> use core scheduling, or, for example, opt in for STIBP. Making the
>> decision, however, requires an extra bit of information which is currently
>> missing: does the topology the guest see match hardware or if it is 'fake'
>> and two vCPUs which look like different cores from guest's perspective can
>> actually be scheduled on the same physical core. Disabling SMT or doing
>> core scheduling only makes sense when the topology is trustworthy.
>>
>> Add two feature bits to KVM: KVM_FEATURE_TRUSTWORTHY_SMT with the meaning
>> that KVM_HINTS_TRUSTWORTHY_SMT bit answers the question if the exposed SMT
>> topology is actually trustworthy. It would, of course, be possible to get
>> away with a single bit (e.g. 'KVM_FEATURE_FAKE_SMT') and not lose backwards
>> compatibility but the current approach looks more straightforward.
> 
> The only way virt topology can make any sense what so ever is if the
> vcpus are pinned to physical CPUs.

This is a subset of the requirements for "trustworthy" SMT.  You can have:

- vCPUs pinned to two threads in the same core and exposed as multiple
cores in the guest

- vCPUs from different guests pinned to two threads in the same core

and that would be okay as far as KVM_HINTS_REALTIME is concerned, but
would still allow exploitation of side-channels, respectively within the
VM and between VMs.

Paolo

> And I was under the impression we already had a bit for that (isn't it
> used to disable paravirt spinlocks and the like?). But I cannot seem to
> find it in a hurry.
> 
> So I would much rather you have a bit that indicates the 1:1 vcpu/cpu
> mapping and if that is set accept the topology information and otherwise
> completely ignore it.
> 

