Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 993A24B0C68
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 12:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241070AbiBJL3i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 06:29:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240929AbiBJL3d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 06:29:33 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28BDF111C;
        Thu, 10 Feb 2022 03:29:09 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id ki18-20020a17090ae91200b001b8be87e9abso1652746pjb.1;
        Thu, 10 Feb 2022 03:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=3KVYoYZA+i3d2/mOOHNlHL4Op7r1hpic6+nbuDj8lV0=;
        b=qe75cX9jmevrdXVrm2ZQ3+mmWPMOkesNVIS4C0Ml3jCmarxyh9i8DF26N8lNDWu+3e
         aDHCG4UxvG7gAg2d04V/wdcSMQXky7YgPeGkAz4JWhk+iRpXaIfe0vFFDCZLLmDvEpoR
         82SDVGJX550Xg6/+7vWmHraV6lCa+kDFZYG+9uvsgGJnC4hJX1ijCpUkn7atYZqmQNDD
         KhlWqZ/DTbGHqpbheWK5UUUGSPTgBAQypZrGa5aVKE6oBdr0xtTDPBtAd91yT9NQ/flg
         sQ+zsVzW3Kx4CdJliJy4PzQ57bkigv7mTdgJsAP218OhsmMFDGuAbdbRN5Znogkt9kzj
         Wc/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=3KVYoYZA+i3d2/mOOHNlHL4Op7r1hpic6+nbuDj8lV0=;
        b=0w8rskmD6M2nMfPukTUEpAnbt46r+xHSOhXS1rOxMDiwqzz7u8rZpQc16rFYD42WmR
         caz4Qn/OxobSPjSrilvQX9+IVSpluHoT+/zUmBWudpio5wzoIIZ0NkbRP4I9/b0iXo8C
         WdOhj+HEqKeEXR0hd4a2+Jro+ZO5lVeSyHNLR6mepd7pTS2bGZkvOisI57Sqo7btlDH6
         8O86XXtAsDVkDgyA2Fw+F/AgN1Hk8+4yEvb5ySq3Q5HHHrUSqC1EDRqqxIofAkn5F6R+
         RqXsJ1zujZzfmWPTbPSvKXnp6ej71VNg+uY9TQn8OAafKDnz8IxabL82sn7RUCB4eTcw
         1kgQ==
X-Gm-Message-State: AOAM532UFMKTMalcTgHgAUhKMvLAQ90AFl6jz5ScisBJRCt7ahkpiyTl
        rwAoqNDNOMdcswnpI4rDs3E=
X-Google-Smtp-Source: ABdhPJxsEvMZh/8/eGu6wg2P7SbwmiOTicNxBavJePmMS4OGu+2hdUYJkNCO4JMkA66GUIPItpsAsA==
X-Received: by 2002:a17:90b:143:: with SMTP id em3mr2305430pjb.29.1644492548719;
        Thu, 10 Feb 2022 03:29:08 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id g19sm4894698pfc.109.2022.02.10.03.29.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 03:29:08 -0800 (PST)
Message-ID: <3bedc79a-5e60-677c-465b-3bc8aa2daad8@gmail.com>
Date:   Thu, 10 Feb 2022 19:28:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH v2 2/6] KVM: x86/pmu: Refactoring find_arch_event() to
 pmc_perf_hw_id()
Content-Language: en-US
To:     "Bangoria, Ravikumar" <ravi.bangoria@amd.com>,
        Kim Phillips <kim.phillips@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Dunn <daviddunn@google.com>,
        Stephane Eranian <eranian@google.com>,
        Jim Mattson <jmattson@google.com>
References: <20211130074221.93635-1-likexu@tencent.com>
 <20211130074221.93635-3-likexu@tencent.com>
 <CALMp9eQG7eqq+u3igApsRDV=tt0LdjZzmD_dC8zw=gt=f5NjSA@mail.gmail.com>
 <7de112b2-e6d1-1f9d-a040-1c4cfee40b22@gmail.com>
 <CALMp9eTVxN34fCV8q53_38R2DxNdR9_1aSoRmF8gKt2yhOMndg@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <CALMp9eTVxN34fCV8q53_38R2DxNdR9_1aSoRmF8gKt2yhOMndg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

cc Kim and Ravi to help confirm more details about this change.

On 10/2/2022 3:30 am, Jim Mattson wrote:
> By the way, the following events from amd_event_mapping[] are not
> listed in the Milan PPR:
> { 0x7d, 0x07, PERF_COUNT_HW_CACHE_REFERENCES }
> { 0x7e, 0x07, PERF_COUNT_HW_CACHE_MISSES }
> { 0xd0, 0x00, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND }
> { 0xd1, 0x00, PERF_COUNT_HW_STALLED_CYCLES_BACKEND }
> 
> Perhaps we should build a table based on amd_f17h_perfmon_event_map[]
> for newer AMD processors?
