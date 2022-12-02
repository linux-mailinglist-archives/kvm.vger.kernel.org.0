Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9259F640E24
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 20:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234359AbiLBTBe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 14:01:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234728AbiLBTBZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 14:01:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A80DEA64
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 11:00:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670007629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w9Z5m9yQev2cpaA+QJwQALcYauXXWIfCXqxuZKsg9Pk=;
        b=gXB7mMuZr4A6zPkxqKHFqXB1lFCRbzRsxeOVv8Jn0H/WxII2/j5tLc7uTk+v/FsxnSiBij
        L89tAraoCK724og//uQGv9NCWXBDdGVPcb6izqxVwNQ4WPKXacAGKmQ4pjolo6mNsxTB4U
        tY/sMFkM8j/BKFhJyXfCreOqOUEo4ts=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-599-sU4gBvoUOduUAAf6XoyONA-1; Fri, 02 Dec 2022 14:00:28 -0500
X-MC-Unique: sU4gBvoUOduUAAf6XoyONA-1
Received: by mail-wm1-f70.google.com with SMTP id c1-20020a7bc001000000b003cfe40fca79so2270404wmb.6
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 11:00:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w9Z5m9yQev2cpaA+QJwQALcYauXXWIfCXqxuZKsg9Pk=;
        b=nvwbQY2H1eNrMvaG9ClrQ/Hb83T5AxZNUOsXKUBFalOFdd3nT4m9WvR5GUgXvUH0c5
         LD+PMzJcRerh+2JU0/esS0sOfBgsl6As0I7+A6rPC8MNHYdVvoq55umhupyq0qZ9bRe4
         9ukl2LbjXO3fUjfOTBKp893OYtrsPP4PKDxTgscfIF3EQWs4uGLfaBIYn1Ii51Imvbm3
         SoVHYTMHIL2llQXtoU5IbXazCSV1v4gET14TzPhzi2ykqM17cVayup/Rhb0xpecf0LDF
         XR/vUbcNKJSA7dUlnBUtOm6MotAGvm7CSAMWDFPbHbVwsGKMWwCXo3Wj7ZkIFWPliy00
         Xrfw==
X-Gm-Message-State: ANoB5plCCs3ne8CgZv6CJk2XTk9rC4SbKmpnTAXO8AcCeom/h0V7A8U3
        XeFbLNUPlWL83iGHLGTxf6D5wy/iMlyp4IvIecuR9iHtmymJ9rwMuSLo9hI4FdKE/V6EvmuQyGf
        iFEEu2mzVTmi1
X-Received: by 2002:a05:600c:4148:b0:3cf:5657:3791 with SMTP id h8-20020a05600c414800b003cf56573791mr42199923wmm.34.1670007626970;
        Fri, 02 Dec 2022 11:00:26 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6SlM06+fiUduURCy/OapWZtEVssDiSo5ymCbtc2x1wact5X5KUX5Vm+HWxJC9HyERHlTX9Ew==
X-Received: by 2002:a05:600c:4148:b0:3cf:5657:3791 with SMTP id h8-20020a05600c414800b003cf56573791mr42199915wmm.34.1670007626695;
        Fri, 02 Dec 2022 11:00:26 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id az39-20020a05600c602700b003cf78aafdd7sm9686497wmb.39.2022.12.02.11.00.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 11:00:26 -0800 (PST)
Message-ID: <561885a1-e1de-21f2-1da9-5abfea2a1045@redhat.com>
Date:   Fri, 2 Dec 2022 20:00:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Paul Durrant <paul@xen.org>, Michal Luczaj <mhal@rbox.co>,
        kvm@vger.kernel.org
References: <20221127122210.248427-1-dwmw2@infradead.org>
 <cd107b6c-ae02-8fa6-50e0-d6cbca7d88bc@redhat.com>
 <24408924dbe6041472f5e401f40c29311e1edd99.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v1 0/2] KVM: x86/xen: Runstate cleanups on top of
 kvm/queue
In-Reply-To: <24408924dbe6041472f5e401f40c29311e1edd99.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/30/22 20:51, David Woodhouse wrote:
> On Wed, 2022-11-30 at 17:03 +0100, Paolo Bonzini wrote:
>> On 11/27/22 13:22, David Woodhouse wrote:
>>> Clean the update code up a little bit by unifying the fast and slow
>>> paths as discussed, and make the update flag conditional to avoid
>>> confusing older guests that don't ask for it.
>>>
>>> On top of kvm/queue as of today at commit da5f28e10aa7d.
>>>
>>> (This is identical to what I sent a couple of minutes ago, except that
>>> this time I didn't forget to Cc the list)
>>>
>>>
>>
>> Merged, thanks.
> 
> Thanks. I've rebased the remaining GPC fixes on top and pushed them out
> (along with Metin's SCHEDOP_poll 32-bit compat support) to
> 
> https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/gpc-fixes

Oh, so we do pull requests now too?  I'm all for it, but please use 
signed tags. :)

> I still haven't reinstated the last of those patches to make gpc->len
> immutable, although I think we concluded it's fine just to make the
> runstate code claim gpc->len=1 and manage its own destiny, right?

Yeah, I'm not super keen on that either, but I guess it can work with 
any of len == 1 or len == PAGE_SIZE - offset.

Related to this, for 6.3 I will send a cleanup of the API to put 
together lock and check.

Paolo

> In reviewing the merge/squash I spotted a minor cosmetic nit in my
> 'Allow XEN_RUNSTATE_UPDATE flag behaviour to be configured' commit.
> It'd be slightly prettier like this, although the compiler really ought
> to emit identical code.
> 
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 5208e05ca9a6..76b7fc6d543a 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -382,7 +382,7 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
>   	entry_time = vx->runstate_entry_time;
>   	if (update_bit) {
>   		entry_time |= XEN_RUNSTATE_UPDATE;
> -		*update_bit = (vx->runstate_entry_time | XEN_RUNSTATE_UPDATE) >> 56;
> +		*update_bit = entry_time >> 56;
>   		smp_wmb();
>   	}
>   
> 
> 

