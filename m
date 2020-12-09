Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3272D4C5B
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 22:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387831AbgLIU7t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 15:59:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbgLIU7q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Dec 2020 15:59:46 -0500
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01A8C0613CF;
        Wed,  9 Dec 2020 12:59:05 -0800 (PST)
Received: by mail-qv1-xf32.google.com with SMTP id l7so1324149qvt.4;
        Wed, 09 Dec 2020 12:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hLr4IoNk4mXvkDggJZgGkE0Lh0R6y+fsYHaJEGIfuuc=;
        b=gphtz3zP8o+6zS3N+NSHv4/V28d6PSJir32f2MrZa2gKRKJDXP6TvwxbeBOq3deiDV
         LlTp1Xc1fAAHw05jQqUsRiHBgY+ruguxqVbvb5cIlP3sy2WcS9YLU0Q5r6+dgB/iJTKB
         vXdpg4K3iNVlSaW+QLGwC6orshyfnLvJ2mg0jYpB8AYnV66ox0Dd0Tv1asOBtczplSjD
         YDAeLZ7WJooce78KC5lMONcwo6GD3XoXqxfLF58l8ufOJZp/UuMkKulOibk9ILEZpfhj
         AkwSNALY3spqQNHSCUdoyrkmftK/32r7rM91m9khiDAb+5KieKcWlZ8xJIKJ13BZCNCP
         oSGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=hLr4IoNk4mXvkDggJZgGkE0Lh0R6y+fsYHaJEGIfuuc=;
        b=sMiJld+mKPSEiab5L9VVUpfoI4QMQXez3EYYuCh7A/HVfx6VfY49p9B519aPlCzrgz
         k/XSEUEIwKzHm2N8Qx/9cuDZgZ90b2uOqBooCOJ1pr5MjuhuUUOATNLS8knHRB+u2u4K
         EiXofb+1CzvPdoyfGMv5txTVTruMzSF+rPX/9gTRHdOodTt1pwivscJEbvSkWWFrqIXJ
         wjHtXWIubw84ep9AMiCW5m3LoNOmSpJFmSTDVgwLwBy1fV+55X9Fj0mjXlDqybHhgo5j
         j/7QNq1atbuIS78niFDvHb+2IOfgwHmkRhVL+W44i0peh8oUDPe9bXcs+mGBaJSgTw7M
         BcJQ==
X-Gm-Message-State: AOAM533F3D6rIWACzMtRKjcct3pXNoSUbMt9Nwcem4MjJpWc2SO3Hcxh
        LjA+cy7IK2Xg6zeA/cD7B0M=
X-Google-Smtp-Source: ABdhPJzok1orIEivGtZa4Drbbb5H+ooHUn+MU52a1sHSyGUAYRV1MwsFMFwtfkzWtn77HZnXC/7jYQ==
X-Received: by 2002:a0c:8e47:: with SMTP id w7mr4983903qvb.55.1607547544798;
        Wed, 09 Dec 2020 12:59:04 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:9bbd])
        by smtp.gmail.com with ESMTPSA id f185sm1971959qkb.119.2020.12.09.12.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 12:59:04 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 9 Dec 2020 15:58:33 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com,
        eric.vantassell@amd.com, pbonzini@redhat.com, seanjc@google.com,
        lizefan@huawei.com, hannes@cmpxchg.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, corbet@lwn.net, joro@8bytes.org,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        gingell@google.com, rientjes@google.com, dionnaglaze@google.com,
        kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch v3 0/2] cgroup: KVM: New Encryption IDs cgroup controller
Message-ID: <X9E6eZaIFDhzrqWO@mtj.duckdns.org>
References: <20201209205413.3391139-1-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209205413.3391139-1-vipinsh@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

Rough take after skimming:

* I don't have an overall objection. In terms of behavior, the only thing
  which stood out was input rejection depending on the current usage. The
  preferred way of handling that is rejecting future allocations rather than
  failing configuration as that makes it impossible e.g. to lower limit and
  drain existing usages from outside the container.

* However, the boilerplate to usefulness ratio doesn't look too good and I
  wonder whether what we should do is adding a generic "misc" controller
  which can host this sort of static hierarchical counting. I'll think more
  on it.

Thanks.

-- 
tejun
