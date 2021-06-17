Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00BFE3AA969
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 05:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhFQDPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 23:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbhFQDPw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Jun 2021 23:15:52 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13143C061574
        for <kvm@vger.kernel.org>; Wed, 16 Jun 2021 20:13:45 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id k7so2934940pjf.5
        for <kvm@vger.kernel.org>; Wed, 16 Jun 2021 20:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=LK0e/zXqoa92GHXVSM0nWPMcz/Pqo2k+ojs5vodEUNo=;
        b=k08oZqD00VNpqV2sYzG8HhNVj8HSDIXjmJI7jiHkB6BaozzME7UksUN90Bkps3NBty
         xGWesecQOqC/kddOKK0kP0zFZ+EYV3y/xlfig1cqT6Dc6OFWCNq3RtXZ/XyNXaxERuo1
         BIkgTw6z+lWkHyq+xL/Im3JYdyONwwGqDA7KO+2R1DLY2BBA3mgj8hg7bgMJy8vUabdW
         tGYUrcsfdTCVY+vKbRkaNQ/Nk3rsWQ89H8ytu4nFXk8+zNw/YPj2E8mmpW8elQ42VXJC
         6k/gXjpe3pvThOrgRwGpi6fSIHkE3l2tVHvEvDf0RggZ6R7d1zjQGsOccE8x7aWHXEtw
         DtJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=LK0e/zXqoa92GHXVSM0nWPMcz/Pqo2k+ojs5vodEUNo=;
        b=eh+KuqYdh0uUV3zc6T0xD83sbg3ErrAJKmkkmAcg7KlHeGFVxXvTv13B8WZhus8TK8
         4Y7/oN4cGiYZxZ7ct3dP644TGh5aQj+Mr7tx7/IH8QKMuLbvvqYSQTc4jm4RjysErJDz
         UAF4b/xKvnWdDBUHc4Hm6IfZ52A6INFhwNh2rCdwVtuBqE85Snofze+v6n70E9euL43r
         qc8hlbd9Q15h/3BDdniYPHzIR8VEoOGf6r/F6lKab/+9fwwICaGzcbepfUMxVbQPqicA
         IQqRrvFBrj/foyQHfWbBpb4GQv5q2L53ygRCvXgXGZgjXkbW9PsQq7cHvmshBECBe1Hr
         YD2g==
X-Gm-Message-State: AOAM533EpFEg/zfq5fxzq94fldQFbsCvPE2346nlSYj5u8QhKNJNUBzC
        Cb34Va4gF1o7e2HxYrDowVF5TOYAQramLr9+
X-Google-Smtp-Source: ABdhPJzuLbquYGicD0qoCPTNLZWheR3sXEQ/O/UiJZ2kc+sCO6VqH8LMNsLGRx1QvfeO7GuOp4hR1g==
X-Received: by 2002:a17:903:49:b029:118:5d88:32ce with SMTP id l9-20020a1709030049b02901185d8832cemr2572224pla.10.1623899624378;
        Wed, 16 Jun 2021 20:13:44 -0700 (PDT)
Received: from [10.11.0.58] ([45.135.186.132])
        by smtp.gmail.com with ESMTPSA id m18sm3431466pff.88.2021.06.16.20.13.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jun 2021 20:13:43 -0700 (PDT)
Subject: Re: [RFC PATCH] iommu: add domain->nested
To:     Christoph Hellwig <hch@lst.de>
Cc:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Auger Eric <eric.auger@redhat.com>,
        jean-philippe <jean-philippe@linaro.org>,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org
References: <1623854282-26121-1-git-send-email-zhangfei.gao@linaro.org>
 <20210616144413.GA2593@lst.de>
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
Message-ID: <ba504241-0442-e76d-8b46-77b686551d80@linaro.org>
Date:   Thu, 17 Jun 2021 11:13:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210616144413.GA2593@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/6/16 下午10:44, Christoph Hellwig wrote:
> On Wed, Jun 16, 2021 at 10:38:02PM +0800, Zhangfei Gao wrote:
>> +++ b/include/linux/iommu.h
>> @@ -87,6 +87,7 @@ struct iommu_domain {
>>   	void *handler_token;
>>   	struct iommu_domain_geometry geometry;
>>   	void *iova_cookie;
>> +	int nested;
> This should probably be a bool : 1;
>
> Also this needs a user, so please just queue up a variant of this for
> the code that eventually relies on this information.
Thanks Christoph

Got it, will do this.


