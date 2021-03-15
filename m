Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE54633C93C
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 23:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbhCOWTp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 18:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbhCOWTh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 18:19:37 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DEA6C06175F;
        Mon, 15 Mar 2021 15:19:37 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id x9so10339619qto.8;
        Mon, 15 Mar 2021 15:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3mc7yshphWRfddErbP6ANAyJjIp9vav1KVv/MqnV+08=;
        b=k4pm+oGHyW/0Hrhbuc7q0+8SgSfdHGYYhPiguGQUh3briuu3jw/5TCyzMGYg8w060V
         MryXnAFafYTZSEg8Y+OqxpfH8TPufBlnRmse3CpAcUakPqZ4TqGz08U1Dp6IHGvZo6dO
         XzvFYARQvIi9vwCArHIBTKB7h0shngcktmS2v27/iOr9YVJOqXHOVsRyLEZeZV/XAEBz
         wTWFgYDv6KA49YfmbS8Kz1BvuHErK/RNw44PjG4hs4LhLyftup1EIv+0wxbGVYDzlIxn
         sKPxsUOx+ytNRtofdhTLCw/ZiSovafjqT75OP8vBE51uc2DsudjKzAuXR9mAJe0PxXw2
         7Y0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=3mc7yshphWRfddErbP6ANAyJjIp9vav1KVv/MqnV+08=;
        b=fhDP/AO+qKTx3lp1qLorflGV5wFmAvIcpV4H5Pwdls3FlQTL4oTzcBQsG+zCJZ7Qz6
         T+E7x/sIr3Qn8vK478HrOBdUv6vhqbGS2Dy9cRXMa/XZSHZo+M9SDl8WPkH0ysZfGoOp
         jbDv65stZjKDXCGJGUhDLsjsc6+FyY+H7r0MBtnzpfIhVbQXagtxnOEPQfQfx1aAQZnR
         /bHvn+tezX8aUESBs/Pjj10L88/27d5L6AcXrU+lyk2KVAJ11ziXLhZwUVUDACGNHPo3
         8ZuKrwPW4R/4iWmNOKB4hQuOhV1ux02RpzphdGBmlN32E1e4UhwE6Bb5AT2K6Ly0JblJ
         B45A==
X-Gm-Message-State: AOAM530NhVJUjbvXGHahEf7MXYUuSJrP+w4bNXvxGDcfVaYkchSA3A/P
        o1fIVL+fVRO7zWl66e5pN+U=
X-Google-Smtp-Source: ABdhPJzvXqprKoAutME/Zx0t4IAmyvOYWNNLf7LhOP5C6LVfWPeE7qFKtLKEj9qf8W3FiHj+NYGgGw==
X-Received: by 2002:ac8:7a95:: with SMTP id x21mr6759670qtr.209.1615846776285;
        Mon, 15 Mar 2021 15:19:36 -0700 (PDT)
Received: from localhost (2603-7000-9602-8233-06d4-c4ff-fe48-9d05.res6.spectrum.com. [2603:7000:9602:8233:6d4:c4ff:fe48:9d05])
        by smtp.gmail.com with ESMTPSA id 6sm12369287qth.82.2021.03.15.15.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 15:19:35 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Mon, 15 Mar 2021 18:19:35 -0400
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
Message-ID: <YE/ddx5+ToNsgUF0@slm.duckdns.org>
References: <20210303185513.27e18fce@jacob-builder>
 <YEB8i6Chq4K/GGF6@google.com>
 <YECfhCJtHUL9cB2L@slm.duckdns.org>
 <20210312125821.22d9bfca@jacob-builder>
 <YEvZ4muXqiSScQ8i@google.com>
 <20210312145904.4071a9d6@jacob-builder>
 <YEyR9181Qgzt+Ps9@mtj.duckdns.org>
 <20210313085701.1fd16a39@jacob-builder>
 <YEz+8HbfkbGgG5Tm@mtj.duckdns.org>
 <20210315151155.383a7e6e@jacob-builder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315151155.383a7e6e@jacob-builder>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On Mon, Mar 15, 2021 at 03:11:55PM -0700, Jacob Pan wrote:
> > Migration itself doesn't have restrictions but all resources are
> > distributed on the same hierarchy, so the controllers are supposed to
> > follow the same conventions that can be implemented by all controllers.
> > 
> Got it, I guess that is the behavior required by the unified hierarchy.
> Cgroup v1 would be ok? But I am guessing we are not extending on v1?

A new cgroup1 only controller is unlikely to be accpeted.

> The IOASIDs are programmed into devices to generate DMA requests tagged
> with them. The IOMMU has a per device IOASID table with each entry has two
> pointers:
>  - the PGD of the guest process.
>  - the PGD of the host process
> 
> The result of this 2 stage/nested translation is that we can share virtual
> address (SVA) between guest process and DMA. The host process needs to
> allocate multiple IOASIDs since one IOASID is needed for each guest process
> who wants SVA.
> 
> The DMA binding among device-IOMMU-process is setup via a series of user
> APIs (e.g. via VFIO).
> 
> If a process calls fork(), the children does not inherit the IOASIDs and
> their bindings. Children who wish to use SVA has to call those APIs to
> establish the binding for themselves.
> 
> Therefore, if a host process allocates 10 IOASIDs then does a
> fork()/clone(), it cannot charge 10 IOASIDs in the new cgroup. i.e. the 10
> IOASIDs stays with the process wherever it goes.
> 
> I feel this fit in the domain model, true?

I still don't get where migration is coming into the picture. Who's
migrating where?

Thanks.

-- 
tejun
