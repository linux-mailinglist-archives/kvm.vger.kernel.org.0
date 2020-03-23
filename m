Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9E7190242
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 00:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbgCWXvD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 19:51:03 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:39413 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727071AbgCWXvC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 19:51:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585007461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fkoyXc5mPqBCz/R4buWFD5GyDb56hM12lE3DoIwJ1ag=;
        b=cRgIL2qPRmX9pJkmiumA6DNiKycUTtChW56nN2z7PbkZdNtQas80NpmuprV8Ol6lf+0oWU
        vlUUl/oGDyPo+2vOP2ikDnIewIpV1qDP/KBA1UhhqV4U7gItWBDXKlwneuNneu8dMrMlQM
        UYvzzYg5oVWoBaXEkNoPDPlHPnlAlmw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-BMSHoXN-OcesGYfC06d16w-1; Mon, 23 Mar 2020 19:51:00 -0400
X-MC-Unique: BMSHoXN-OcesGYfC06d16w-1
Received: by mail-wr1-f69.google.com with SMTP id e10so5539546wrm.2
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 16:50:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fkoyXc5mPqBCz/R4buWFD5GyDb56hM12lE3DoIwJ1ag=;
        b=dJ9PAzmckDgJzE4WQfOW5DQQgpdrwQA/jpJPhL1UtsU9bX3qBvYf02gfuMRBuBNReg
         yziMS5uRMseo8XhqWIOvAg1+hBF1eG5WZw5MRiTjI2c+AkZkJL8K85RpzsXcglc16tDh
         Ow0fmNEmj8UJuvSOM3LvWpXpCqmgp5xyT5Po8LzEO/riqwQQh9ZFSMfq08IEc4v24Fsc
         96KPOo+7L3j4toa8SBH4rWHQlPhe/DQ4SO9wxM0tMT8bgKnMmXCzfcf9ZYU61CNjcHPw
         doTz2oc2dMpj5mFJ2376oLmev/z5HygOYMvBUpY1Q0Dcgu8+/r9WwlZ3Nl4TglHBSUCs
         /EGA==
X-Gm-Message-State: ANhLgQ2xOQ2bHKxKNnMfDSVgpMUU89p4paQAYLC5Ar2XOR46zKc2os9j
        gbzshimO95ymgIlVScPJ287GY9m57SxsdYDw0K5xIU/a9dRqJ9LYy1nf35LXesqRHFIKVwew2kF
        Y0KJNW/YkgpG/
X-Received: by 2002:a05:6000:1251:: with SMTP id j17mr16473488wrx.228.1585007457867;
        Mon, 23 Mar 2020 16:50:57 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsOy8DXJXcdx0vvDGI7IevKM2IukdVaVZbmxFnSFjwbFv1Wp5JWRKray+ne4w05EP+Db72IPA==
X-Received: by 2002:a05:6000:1251:: with SMTP id j17mr16473474wrx.228.1585007457630;
        Mon, 23 Mar 2020 16:50:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7848:99b4:482a:e888? ([2001:b07:6468:f312:7848:99b4:482a:e888])
        by smtp.gmail.com with ESMTPSA id o67sm1695824wmo.5.2020.03.23.16.50.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2020 16:50:57 -0700 (PDT)
Subject: Re: [PATCH v3 03/37] KVM: nVMX: Invalidate all EPTP contexts when
 emulating INVEPT for L1
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
 <20200320212833.3507-4-sean.j.christopherson@intel.com>
 <CALMp9eR5Uu7nRDOS2nQHGzb+Gi6vjDEk1AmuiqkkGWFjKNG+sA@mail.gmail.com>
 <20200323162807.GN28711@linux.intel.com>
 <CALMp9eR42eM7g81EgHieyNky+kP2mycO7UyMN+y2ibLoqrD2Yg@mail.gmail.com>
 <20200323164447.GQ28711@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8d99cdf0-606a-f4df-35e7-3b856bb3ea0e@redhat.com>
Date:   Tue, 24 Mar 2020 00:50:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200323164447.GQ28711@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/03/20 17:44, Sean Christopherson wrote:
> So I think
> 
>   Fixes: 14c07ad89f4d ("x86/kvm/mmu: introduce guest_mmu")
> 
> would be appropriate?
> 

Yes.  I changed it and also added the comment

+		/*
+		 * Nested EPT roots are always held through guest_mmu,
+		 * not root_mmu.
+		 */

which isn't unlike what you suggested elsewhere in the thread.

Paolo

