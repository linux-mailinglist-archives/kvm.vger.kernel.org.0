Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF54B4C957C
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 21:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237644AbiCAUNd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 15:13:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237618AbiCAUNb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 15:13:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1BD3225EBE
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 12:12:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646165566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kUL9utw17ggwuAli/GlAqssIM3wigY+ILrUoFV3hSoM=;
        b=PdzI8+1hk8FlmvSjeoAjI4fLNAhzMjIhj8qhuq5lkB9gZwdB14ShLUqGnypUwfHE8YRyOi
        ZsVTNW59+XigHUaHnBVizXK0DJCZekrsMxrfwLrpglt2D6w1gQwQvtW6QuGVI6ObAv1TZH
        BhsPf2vRoXrbljrWpiODzHTt5bK3m1g=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-323-AevP8yWfMTa_XqnMdn3GYw-1; Tue, 01 Mar 2022 15:12:43 -0500
X-MC-Unique: AevP8yWfMTa_XqnMdn3GYw-1
Received: by mail-wm1-f71.google.com with SMTP id f25-20020a1c6a19000000b003813f25a33aso1201166wmc.1
        for <kvm@vger.kernel.org>; Tue, 01 Mar 2022 12:12:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kUL9utw17ggwuAli/GlAqssIM3wigY+ILrUoFV3hSoM=;
        b=F2g0behjGwkd2M76ez50bviFjuG1oQfiAYc9ImvvM1z0ycroBS1ovrdpbhHJJkduuM
         Mtcv4rFzKZ+XWiJ0Nosrc8HMNRCAL00H0PW9BOk6uYELDq+lwJ/IXw+Kz9YVUMFfOYez
         PK4x1aMS3+JC0hQcslxEafJh/nHN5Z0keHIXb1NchczYlOMHd+uJvM3d9A5EAIC65Jz/
         aL+pwheKLcGTpMGWO/nO7yM0WbDWoxB9mEAJP3e7BVp0J84RC1t8Wn0C335Zp8WZQNs3
         vA2yKhxww/ZDLtl1NySi64l5dyKuwLyT+HF+Ys85NJkDgxRoEDcWsvxoy889sd+A1Sn+
         xPXQ==
X-Gm-Message-State: AOAM5322qlewUidZTaTbX/TdRn3MEG1BbXCR0bqHSI03jd0iB3UfD7k3
        q98vDWY0FkvYzLspI4n9V6baWKr7CnAKQWkFvjTttMrl8DraYLakogvK4plxpyBdkS4G/YP6T9h
        zunCzlbqyUC+s
X-Received: by 2002:a05:600c:1d1f:b0:381:4146:bcd9 with SMTP id l31-20020a05600c1d1f00b003814146bcd9mr15607295wms.69.1646165561820;
        Tue, 01 Mar 2022 12:12:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxU0cx8bRi3mlhUWzUAEJSXjw3hX6vV+cLQs5XnWT1Bft/chRXuWwxeF43jYoFaCBpyw6jj+w==
X-Received: by 2002:a05:600c:1d1f:b0:381:4146:bcd9 with SMTP id l31-20020a05600c1d1f00b003814146bcd9mr15607276wms.69.1646165561512;
        Tue, 01 Mar 2022 12:12:41 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id z3-20020a1cf403000000b0037d1f4a2201sm3401809wma.21.2022.03.01.12.12.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 12:12:40 -0800 (PST)
Message-ID: <f444790d-3bc7-9870-576e-29f30354a63b@redhat.com>
Date:   Tue, 1 Mar 2022 21:12:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 20/28] KVM: x86/mmu: Allow yielding when zapping GFNs
 for defunct TDP MMU root
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-21-seanjc@google.com>
 <28276890-c90c-e9a9-3cab-15264617ef5a@redhat.com>
 <Yh53V23gSJ6jphnS@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yh53V23gSJ6jphnS@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/1/22 20:43, Sean Christopherson wrote:
>> and after spending quite some time I wonder if all this should just be
>>
>>          if (refcount_dec_not_one(&root->tdp_mmu_root_count))
>>                  return;
>>
>> 	if (!xchg(&root->role.invalid, true) {
> 
> The refcount being '1' means there's another task currently using root, marking
> the root invalid will mean checks on the root's validity are non-deterministic
> for the other task.

Do you mean it's not possible to use refcount_dec_not_one, otherwise 
kvm_tdp_mmu_get_root is not guaranteed to reject the root?

>> 	 	tdp_mmu_zap_root(kvm, root, shared);
>>
>> 		/*
>> 		 * Do not assume the refcount is still 1: because
>> 		 * tdp_mmu_zap_root can yield, a different task
>> 		 * might have grabbed a reference to this root.
>> 		 *
>> 	        if (refcount_dec_not_one(&root->tdp_mmu_root_count))
> 
> This is wrong, _this_ task can't drop a reference taken by the other task.

This is essentially the "kvm_tdp_mmu_put_root(kvm, root, shared);" (or 
"goto beginning_of_function;") part of your patch.

>>          	        return;
>> 	}
>>
>> 	/*
>> 	 * The root is invalid, and its reference count has reached
>> 	 * zero.  It must have been zapped either in the "if" above or
>> 	 * by someone else, and we're definitely the last thread to see
>> 	 * it apart from RCU-protected page table walks.
>> 	 */
>> 	refcount_set(&root->tdp_mmu_root_count, 0);
> 
> Not sure what you intended here, KVM should never force a refcount to '0'.

It's turning a refcount_dec_not_one into a refcount_dec_and_test.  It 
seems legit to me, because the only refcount_inc_not_zero is in a 
write-side critical section.  If the refcount goes to zero on the 
read-side, the root is gone for good.

> xchg() is a very good idea.  The smp_mb_*() stuff was carried over from the previous
> version where this sequence set another flag in addition to role.invalid.
> 
> Is this less funky (untested)?
> 
> 	/*
> 	 * Invalidate the root to prevent it from being reused by a vCPU while
> 	 * the root is being zapped, i.e. to allow yielding while zapping the
> 	 * root (see below).
> 	 *
> 	 * Free the root if it's already invalid.  Invalid roots must be zapped
> 	 * before their last reference is put, i.e. there's no work to be done,
> 	 * and all roots must be invalidated before they're freed (this code).
> 	 * Re-zapping invalid roots would put KVM into an infinite loop.
> 	 *
> 	 * Note, xchg() provides an implicit barrier to ensure role.invalid is
> 	 * visible if a concurrent reader acquires a reference after the root's
> 	 * refcount is reset.
> 	 */
> 	if (xchg(root->role.invalid, true))
> 		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> 		list_del_rcu(&root->link);
> 		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> 
> 		call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
> 		return;
> 	}

Based on my own version, I guess you mean (without comments due to 
family NMI):

         if (!refcount_dec_and_test(&root->tdp_mmu_root_count))
                 return;

	if (!xchg(&root->role.invalid, true) {
		refcount_set(&root->tdp_mmu_count, 1);
	 	tdp_mmu_zap_root(kvm, root, shared);
	        if (!refcount_dec_and_test(&root->tdp_mmu_root_count))
         	        return;
	}

         spin_lock(&kvm->arch.tdp_mmu_pages_lock);
         list_del_rcu(&root->link);
         spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
         call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);

Paolo

