Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 962007D580B
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 18:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343878AbjJXQXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 12:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234738AbjJXQWz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 12:22:55 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE46B10E9
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 09:22:45 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-4081ccf69dcso32750255e9.0
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 09:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698164564; x=1698769364; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=e3Lw885OKwVMAKJ+lcANwbqiLUJvnaLF4rMzyVhxCiE=;
        b=fUELXNTi3EaklLJZ0a0oGp8HRw1C2vbnBlh8JmY24pzn4LOcqXtIDJ9YUJRknKB/IM
         ybYddYq03kWkHhu1OQz0QVuYhyarmVZUmrp8Js8PH2mEat5e1JBvvry9rLd7tYSqQjsU
         R57jqyEtKTvdbzLhDWZR/f4nZHYUF2z4zsXAczMyE2pYuuaZjV1VyVtsruXgh0ZZszBG
         KwxFz8noRHRVfcEDqfqBfWvd6KbEYxPIeDAci3zJpjHfYqh1uYVfV+RrATjeWROSIAgE
         clnAqig6FjYM0JAEG2GZC7WlIFxm2ukQ7iHc0FTAcd10KqRU93YnEqIQHD/kxgUMJSa7
         gVJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698164564; x=1698769364;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e3Lw885OKwVMAKJ+lcANwbqiLUJvnaLF4rMzyVhxCiE=;
        b=BQX7cIsHRxh2o6DiODEXvJSh9aiJM3moHH6FVlMTh4M/OpjxsvIceFZAHenmV7zgLy
         kKMyDN8PHmBSeUWWXL8ATH9QhcHDk3wO8GjJMNhR+0QDwEt0SYQ+5n4E7mZTLRz/BvNv
         pdD8TIZfZg63OJLRBeR68en8XoIuSibT/SBiTp8KxAr7hriaBCjcsOP0NeW+h+GRFdto
         6okwmjXlRorPrz0uZe1rxFaizR44RiV2KlUBHRSvFfR2loTWEriu/3Jrd2qJCS6huygU
         TS51YLwyE8Ykrt+0+BmufGdQwUIgjudNfn6exr1oqtTiUPkbyM5888vlNmq7dqSsR06n
         zLgQ==
X-Gm-Message-State: AOJu0Yz71nNpSUPxBzs0eUFi1Niw8T7Uy7T8Ce2gO0izhyIZRgWkJTzV
        p7xwuPFjPSX9afx0wOX+Dto=
X-Google-Smtp-Source: AGHT+IGE5clc2rOnE6leeciZfVRiFGqwOxcrDHe1tg4zz2ecPacv7kXaqp1axxGRcGZHMciB9vvCKw==
X-Received: by 2002:adf:b1d1:0:b0:32d:c755:d73d with SMTP id r17-20020adfb1d1000000b0032dc755d73dmr14284793wra.18.1698164564123;
        Tue, 24 Oct 2023 09:22:44 -0700 (PDT)
Received: from [192.168.6.66] (54-240-197-230.amazon.com. [54.240.197.230])
        by smtp.gmail.com with ESMTPSA id h12-20020adff18c000000b0032d402f816csm10104046wro.98.2023.10.24.09.22.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 09:22:43 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <ab2aabe5-b3c3-43f5-812e-bce98d2e59ae@xen.org>
Date:   Tue, 24 Oct 2023 17:22:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 16/24] hw/xen: handle soft reset for primary console
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Cleber Rosa <crosa@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Beraldo Leal <bleal@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Bernhard Beschow <shentey@gmail.com>,
        Joel Upham <jupham125@gmail.com>
References: <20231019154020.99080-1-dwmw2@infradead.org>
 <20231019154020.99080-17-dwmw2@infradead.org>
 <8ba01df3-6189-4e1e-a70f-37a2d4dd21ed@xen.org>
 <3124d1d6e9af139a3c7b6dbe2b73a82914d3f559.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <3124d1d6e9af139a3c7b6dbe2b73a82914d3f559.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/10/2023 16:48, David Woodhouse wrote:
> On Tue, 2023-10-24 at 16:44 +0100, Paul Durrant wrote:
>> On 19/10/2023 16:40, David Woodhouse wrote:
>>> From: David Woodhouse <dwmw@amazon.co.uk>
>>>
>>> On soft reset, the prinary console event channel needs to be rebound to
>>> the backend port (in the xen-console driver). We could put that into the
>>> xen-console driver itself, but it's slightly less ugly to keep it within
>>> the KVM/Xen code, by stashing the backend port# on event channel reset
>>> and then rebinding in the primary console reset when it has to recreate
>>> the guest port anyway.
>>
>> Does Xen re-bind the primary console on EVTCHNOP_reset? That's news to
>> me. I go check.
> 
> I spent an unhapp hour trying to work out how Xen actually does any of
> this :)
> 
> In the short term I'm more interested in having soft reset work, than
> an explicit EVTCHNOP_reset. And I can't work out *how*, but we do seem
> to have console again after a kexec in real Xen.

*Soft* reset may do it, but not the EVTCHNOP_reset hypercall itself, 
because there's a bunch of impenetrable toolstack magic involved the 
former. Perhaps you could just push the re-bind code up a layer into
kvm_xen_soft_reset().

   Paul
