Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1FE339D89
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 11:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233248AbhCMKV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Mar 2021 05:21:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbhCMKVo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Mar 2021 05:21:44 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C84BC061574;
        Sat, 13 Mar 2021 02:21:44 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id b130so26989772qkc.10;
        Sat, 13 Mar 2021 02:21:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UpX1Lg+mq54WtiAhrwBDWXYDPmqQUSFtcUwtNY+v8RQ=;
        b=FS0YqOTWPrsR8T8rB+TOtNMqfIpKjZbMujx1QpqRgZjz+StMzp0ESXTxK/LGZVIOsP
         9J/ID9iq3J8fZXg6Zvd+AZeFr0D4YkkTPs8aOslYrPBSny6+99XB8x6oEohV8QVCe77t
         cUb0BW4BeNSoNY+qqwndaQGB63Hxq/SUFNI/zOzGmYw9u8iUbebYf6K0V012N05CS6MU
         HkIJs4hs3gGUSxMlZ1Fh6L2Gc3+begGLpY1xDxOeF1bLTazwfYrTo9ed3PR2AFrzSZHL
         aUwrIpg9owREHwMHERhVCTJp9HrkZ26YA1xMQIDqfyU3uRlaMJYeB8puRxRmsdcEjhCI
         OInA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=UpX1Lg+mq54WtiAhrwBDWXYDPmqQUSFtcUwtNY+v8RQ=;
        b=TOs1rCxAk0veONv7kDC8O8wkAHQ/H7ZrnYpgYkq3nH+sYywMkdUlAd6Duw3fGFDmPh
         /GNOtRjj+IktzIIg2G6TLl5rNbIHDYtAfpMukwKNzhNtwor6P6pntTZBZolsV2A6XVaN
         UrEwsVInrEDCsmSo6G3PwW2+o5FYeIojQ48qwsQPfLt0obeMIlAG0/XBezMiClCPeHdC
         uRxnZuhoqdYvAcwPH/apZNO3AsBtjqdVuKaYsYaDY41GNUCswBbKR7Dy03mQgqGwfLzt
         jsJ5jRMaTDZRpZmeckDxhVII8/VDBoSasGZKRSGCIN66vv2a8+67ncUK+Febt56qMY+5
         QFPw==
X-Gm-Message-State: AOAM533A001jVMpWQPPx+pyTE7DGUcWHm+p3TPj28SyPvFeRWRvnZkCT
        ohW7Ciug+1D3w+KfkbYfXTE=
X-Google-Smtp-Source: ABdhPJzvrDsFGZRbsgl4wu3pGJt4hqTE0dedEbZoaS2lE81Ko30AmIDxkFn/Hgy8XduDR4fInx5ipQ==
X-Received: by 2002:a37:6348:: with SMTP id x69mr16074698qkb.154.1615630903056;
        Sat, 13 Mar 2021 02:21:43 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:26b6])
        by smtp.gmail.com with ESMTPSA id r125sm6279413qkf.132.2021.03.13.02.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Mar 2021 02:21:42 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Sat, 13 Mar 2021 05:20:39 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Jacob Pan <jacob.jun.pan@intel.com>
Cc:     Vipin Sharma <vipinsh@google.com>, mkoutny@suse.com,
        rdunlap@infradead.org, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com,
        pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, gingell@google.com,
        rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>
Subject: Re: [RFC v2 2/2] cgroup: sev: Miscellaneous cgroup documentation.
Message-ID: <YEyR9181Qgzt+Ps9@mtj.duckdns.org>
References: <20210302081705.1990283-1-vipinsh@google.com>
 <20210302081705.1990283-3-vipinsh@google.com>
 <20210303185513.27e18fce@jacob-builder>
 <YEB8i6Chq4K/GGF6@google.com>
 <YECfhCJtHUL9cB2L@slm.duckdns.org>
 <20210312125821.22d9bfca@jacob-builder>
 <YEvZ4muXqiSScQ8i@google.com>
 <20210312145904.4071a9d6@jacob-builder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312145904.4071a9d6@jacob-builder>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 12, 2021 at 02:59:04PM -0800, Jacob Pan wrote:
> Our primary goal is to limit the amount of IOASIDs that VMs can allocate.
> If a VM is migrated to a different cgroup, I think we need to
> charge/uncharge the destination/source cgroup in order enforce the limit. I
> am not an expert here, any feedback would be appreciated.

That simply isn't a supported usage model. None of other resources will get
tracked if you do that.

Thanks.

-- 
tejun
