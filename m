Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C9E3C5ADA
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 13:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbhGLKhV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 06:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234100AbhGLKhR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 06:37:17 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D40DC0613E5;
        Mon, 12 Jul 2021 03:34:28 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id j199so15990183pfd.7;
        Mon, 12 Jul 2021 03:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bZZ+r9TAdHHsxLCRnmElJouEcg6KlMoFa+SwP9B2Hb8=;
        b=n07LaDd+Q7BHFZ1vVP3/p0OAnGpuEo1aN5MQHACQHE+5AQKxKeOngqDi/cktBfJ5au
         VsXgFGRxJKYwn04MOnbCGX/4+k8F0GrlH90Z9UNIGBYE1YebAawjlIIXdslozBdMcFTb
         cqL4vbjG7/94hBU3at723lOA/N9VtYyNMnNn2TIjsf1DTT4KRInKDGMKiv066Yn5m1GD
         2OYPMS36P1P5LZL5JNre5JyrOfdwYbPVjChMsLs+XNKU5Q2/AeiDBID27WhDQeYcI1vO
         T1j3g73S69kfFDVXPxDNCbNbU9wiNFTXLOJlfiOivdb8P5ltxFQT8iN3l5KgMlUqnpoP
         mHfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bZZ+r9TAdHHsxLCRnmElJouEcg6KlMoFa+SwP9B2Hb8=;
        b=LasItA0joza+ExQm27QLPgfiA9gVUJeoZlsdV7wKa+yEXWSSSnJNRPChGTqYl+nMIu
         QqC2VxRmciV/t757CchkG1mJb3PJgNElNsfovBZsTbTkVuNmpfRB2WF/TZPj8Jp42nZ7
         22T4MICHB0rG45j4/ePyweR5BaVM7setkDlXTATC8RuoG/dhLtsdPhtSAl8EoIfJUpOh
         uTgoPBDzzROr4YwGy/+mY1wi8ggbD/g/PnL9FJEOOuPtIyF1O3gtmNyLXPODewDsS6bb
         wTp6Vp//h7fc+9jH2DO1v8qb+v/7xg1RL++ePIk+Ue+uOeWazQE81+mpH8UaprfSA3MG
         Iy1g==
X-Gm-Message-State: AOAM5317ucN9lIGBVgzgEh7nSxmDp3wavfLbrJZhQ+Exxd8bgb136dko
        XtKGsM63nN0qNQssEyxcPGA=
X-Google-Smtp-Source: ABdhPJwxaxzVfwaz971hhX33+UhGltIgWQMW5Y3fx9QbUmbuDSwJRSgYHxNK4f01wYPASuV2LUc6oA==
X-Received: by 2002:a63:1a5b:: with SMTP id a27mr53401043pgm.427.1626086068019;
        Mon, 12 Jul 2021 03:34:28 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id nl2sm3803193pjb.10.2021.07.12.03.34.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 03:34:27 -0700 (PDT)
Subject: Re: [PATCH V7 00/18] KVM: x86/pmu: Add *basic* support to enable
 guest PEBS via DS
To:     Liuxiangdong <liuxiangdong5@huawei.com>, lingshan.zhu@intel.com
Cc:     ak@linux.intel.com, bp@alien8.de, eranian@google.com,
        jmattson@google.com, joro@8bytes.org, kan.liang@linux.intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, peterz@infradead.org, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, wei.w.wang@intel.com,
        weijiang.yang@intel.com, x86@kernel.org,
        "Fangyi (Eric)" <eric.fangyi@huawei.com>,
        Xiexiangyou <xiexiangyou@huawei.com>
References: <20210622094306.8336-1-lingshan.zhu@intel.com>
 <60EB9CD8.6080608@huawei.com>
From:   Like Xu <like.xu.linux@gmail.com>
Message-ID: <19b7db9e-ccde-ca1f-3e17-09e718a1f3a4@gmail.com>
Date:   Mon, 12 Jul 2021 18:34:17 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <60EB9CD8.6080608@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/2021 9:37 am, Liuxiangdong wrote:
> Hi， Lingshan.
> 
> We can use basic pebs for KVM Guest on ICX by this patches set. Will we 
> consider supporting "perf mem" for KVM Guest?
> 

I suggest we can enable more advanced PEBS features
after the basic support hits the mainline.

> AFAIK, the load latency facility requires processor supporting PEBS. 
> Besides, it needs MSR_PEBS_LD_LAT_THRESHOLD
> msr (3F6H) to specify the desired latency threshold. How about 
> passthrough this msr to Guest?
> 
> Thanks!
> Xiangdong Liu
> 
> 
