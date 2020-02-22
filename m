Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB624168E98
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2020 12:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgBVLus (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Feb 2020 06:50:48 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42358 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbgBVLuq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Feb 2020 06:50:46 -0500
Received: by mail-qt1-f196.google.com with SMTP id r5so3277989qtt.9
        for <kvm@vger.kernel.org>; Sat, 22 Feb 2020 03:50:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=2oHoyb+JnJcDOD/ld8MPLRq6aXjPEqdTgiqvEEYJPd8=;
        b=UvU7VmeTFofcFZ9EDyr5Eo2X0bUAaQkJDkcQZfEv9tc6jLZOG2L8jk/+HM5ka3PuY5
         bEWz/lz7o8O+GDrt4gXzLX26fGcGkWH0d3BmCO5KYZpUstTsFnx9ygugZAujF7AEOsfs
         7GhmB/lVeDzvDgpRDO/TNGmJHsQCQo49hc2GTsHB9QR2M8yWaj84wK/jkhVT6yUVcP5S
         jfLwPzXFxz98EazAK2gSjekGKI6SJTPfjMTxuLG0849z/AzYDbrNjhuwRV23VR4BAVRL
         ENmM5UBKIBW6IQ10avK0/lVPjFXZJ/TcAT5HKCOqsMAZMs02yxWmrihVyG7/bUnXd10j
         abKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=2oHoyb+JnJcDOD/ld8MPLRq6aXjPEqdTgiqvEEYJPd8=;
        b=CBNdExVHuHuCPsI7v+ILWDw9gmB42e/Sv5/XTunEKxuzQFpq5AqjcVc+V1Z7qknSb9
         M9x/B63HfntKvuUYlM2BPCBduWC1iHZ7tbe+/jYHfySaD5eM8GL6z6zCO6e1fv2o7+Sr
         m2mmfzVO4pHKlSN64gc9hBfFAA10U5JUe9L3SdUQVJamUsZkpLBbDYoJlSuiQqp0PLQJ
         LBVw1+PXVtsLc+hXshLFwDvuT9mg38DUJSkHsPO2za1/Gv5Z5uH7j2g2vnqantMVK2oV
         VSLsWZveMZiIT8zutKNkf07p7X24BROqXEqx2dc/fAuh3ku95ZPT4B8cBYAiK4HH7n9V
         nYJg==
X-Gm-Message-State: APjAAAXf8ja4lyDb4yOHkY/hLDfC+nlQESic7f3obOJuJ7s2PnOiYGFU
        VFyq+ZD1b60vIiY+pD19B1In2w==
X-Google-Smtp-Source: APXvYqyPZZBj5jHH9s08zRFxGWurtD5EPWlHOyvqtpdas4/Y/9wlrObBtktabH81aDv065MOxAxg+w==
X-Received: by 2002:aed:2167:: with SMTP id 94mr35462329qtc.318.1582372244475;
        Sat, 22 Feb 2020 03:50:44 -0800 (PST)
Received: from [192.168.1.183] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id g84sm2962048qke.129.2020.02.22.03.50.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Feb 2020 03:50:43 -0800 (PST)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
From:   Qian Cai <cai@lca.pw>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2] mm/hugetlb: fix a addressing exception caused by huge_pte_offset()
Date:   Sat, 22 Feb 2020 06:50:42 -0500
Message-Id: <D70C23C6-75CB-4A68-8E7C-23FE8A0CCA68@lca.pw>
References: <f274b368-6fdb-2ae3-160e-fd8b105b9ac4@huawei.com>
Cc:     akpm@linux-foundation.org, mike.kravetz@oracle.com,
        kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org,
        arei.gonglei@huawei.com, weidong.huang@huawei.com,
        weifuqiang@huawei.com, kvm@vger.kernel.org, linux-mm@kvack.org,
        Matthew Wilcox <willy@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org
In-Reply-To: <f274b368-6fdb-2ae3-160e-fd8b105b9ac4@huawei.com>
To:     "Longpeng (Mike)" <longpeng2@huawei.com>
X-Mailer: iPhone Mail (17D50)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Feb 22, 2020, at 1:33 AM, Longpeng (Mike) <longpeng2@huawei.com> wrote:=

>=20
> As explained in the commit messages, it's for safe(e.g. avoid the compilie=
r
> mischief). You can also find the same usage in the ARM64's huge_pte_offset=
() in
> arch/arm64/mm/hugetlbpage.c

Rather than blindly copy over there, are those correct here? What kind of ba=
d compiler optimizations exactly do they try to prevent? Until we understand=
 those details, blindly adding READ_ONCE() will only hide other problems.=
