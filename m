Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4CB64AC8
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 18:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbfGJQdk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 12:33:40 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41596 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727210AbfGJQdk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 12:33:40 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so3151770wrm.8
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2019 09:33:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QSfs5lRZdd4LaYr7BiGa6p8wGMXLlowEwCEikfpblMg=;
        b=B6EOsFCIHbxgAKAh2MKCevAoVsMu540lVcdDR68PHPG494/7gcn8CZmalCGRJCLngB
         9bdl2+nxyjvthQhWq4Y8uwxudWXlffgWIpdeYSftqRslFowXCdcGupCB+I78Mkgp5O5Q
         urM1agcEtxf0ZydUGnRXG6DQwRjeqjm818StfEa3CKCN9Wd5Lz1JOyBC2ASrb1Jw72II
         WS0Hzcv0Im6IuuC/kl9ORxQnGkPfrKOIvfm99VyO2EHKyMDHOR1FEIcjzAVvLTJ37tlY
         eapCWoZ+pgbEKaEDwZPo8WFeKq5dUx3LopLmdVVmq6KY7NkL78/1a7Y4y30TuONHGTUK
         mfnQ==
X-Gm-Message-State: APjAAAW6JLm2v8TiZPqyoIixpTxJl45wRsgmOD7aaj7oC57ZYO3ra4/C
        BcP0Y4SOaVgexnpbuv+BVOjr5ithoCQ=
X-Google-Smtp-Source: APXvYqyJjmeVPAkdqAX6JAm9yaGNjF2efb4B/soDsX8kp0urQOjNqab4k+TgOStaVARRyB20Kx0d6Q==
X-Received: by 2002:adf:d4cc:: with SMTP id w12mr33019261wrk.121.1562776418492;
        Wed, 10 Jul 2019 09:33:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d066:6881:ec69:75ab? ([2001:b07:6468:f312:d066:6881:ec69:75ab])
        by smtp.gmail.com with ESMTPSA id u1sm2831290wml.14.2019.07.10.09.33.37
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 09:33:37 -0700 (PDT)
Subject: Re: [PATCH 0/5] KVM: nVMX: Skip vmentry checks that are necessary
 only if VMCS12 is dirty
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org,
        rkrcmar@redhat.com, jmattson@google.com
References: <20190707071147.11651-1-krish.sadhukhan@oracle.com>
 <20190708181759.GB20791@linux.intel.com>
 <4a9a76e4-a40c-58a6-4768-1125f6193c81@redhat.com>
 <20190710161519.GC4348@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ccd5a3d5-1201-bc1d-a3c8-81414026f1d9@redhat.com>
Date:   Wed, 10 Jul 2019 18:33:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190710161519.GC4348@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/07/19 18:15, Sean Christopherson wrote:
> On Wed, Jul 10, 2019 at 04:35:46PM +0200, Paolo Bonzini wrote:
>> On 08/07/19 20:17, Sean Christopherson wrote:
>>> On Sun, Jul 07, 2019 at 03:11:42AM -0400, Krish Sadhukhan wrote:
>>>> The following functions,
>>>>
>>>> 	nested_vmx_check_controls
>>>> 	nested_vmx_check_host_state
>>>> 	nested_vmx_check_guest_state
>>>>
>>>> do a number of vmentry checks for VMCS12. However, not all of these checks need
>>>> to be executed on every vmentry. This patchset makes some of these vmentry
>>>> checks optional based on the state of VMCS12 in that if VMCS12 is dirty, only
>>>> then the checks will be executed. This will reduce performance impact on
>>>> vmentry of nested guests.
>>>
>>> All of these patches break vmx_set_nested_state(), which sets dirty_vmcs12
>>> only after the aforementioned consistency checks pass.
>>>
>>> The new nomenclature for the dirty paths is "rare", not "full".
>>>
>>> In general, I dislike directly associating the consistency checks with
>>> dirty_vmcs12.
>>>
>>>   - It's difficult to assess the correctness of the resulting code, e.g.
>>>     changing CPU_BASED_VM_EXEC_CONTROL doesn't set dirty_vmcs12, which
>>>     calls into question any and all SECONDARY_VM_EXEC_CONTROL checks since
>>>     an L1 could toggle CPU_BASED_ACTIVATE_SECONDARY_CONTROLS.
>>
>> Yes, CPU-based controls are tricky and should not be changed.  But I
>> don't see a big issue apart from the CPU-based controls, and the other
>> checks can also be quite expensive---and the point of dirty_vmcs12 and
>> shadow VMCS is that we _can_ exclude them most of the time.
> 
> No argument there.  My thought was do something like the following so that
> all of the "which checks should we perform" logic is consolidated in a
> single location and not spread piecemeal throughout the checks themselves.
> 
> static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
> {
> 	unsigned long dirty_checks;
> 
> 	...
> 
> 	if (vmx->nested.dirty_vmcs12)
> 		dirty_checks = ENTRY_CONTROLS | EXIT_CONTROLS | HOST_STATE |
> 			       GUEST_STATE;
> 	else
> 		dirty_checks = 0;
> }

That makes sense, though it would be somewhat awkward:

	dirty_checks = EXEC_CONTROLS | HOST_STATE_FSGS |
		ENTRY_CONTROLS_INTRINFO | GUEST_STATE_EFER;
	if (vmx->nested.dirty_vmcs12)
		dirty_checks |= ENTRY_CONTROLS_FULL | EXIT_CONTROLS |
			HOST_STATE_FULL | GUEST_STATE_FULL;

Paolo
