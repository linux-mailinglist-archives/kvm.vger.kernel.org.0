Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 738B5636755
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 18:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238761AbiKWRhm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 12:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237359AbiKWRhk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 12:37:40 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1D413CCD
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 09:37:38 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id y14-20020a17090a2b4e00b002189a1b84d4so2469417pjc.2
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 09:37:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BTJPrqrqSEwhgHq/Fq7SqerFqPYBOzBQre48SjGb0AQ=;
        b=AXeIwTvPHhsokCd+EErazsQ8K+lGrncHyEuqRtdoyXhSyIF6UVoIlnqPmu2VPCED60
         mHOMk9yvQi+Gkq2gElaHXoFKHK98cKz3dh0r+qnBWB8mkJErZXQtp2n65JXr0nQZLPTv
         l+uls76z3THb1hzYMsRVgcWtdRMNwMFmxSUgM7S+eDqYs+GCbQPXKxO2yJVTGAP/ciN3
         k52M91Nm7cY14fq1v5NDox/uaxslvzh9LZZ0HZ4tYPTwqi75XfG+zmcNIOM4Ob0iU4rM
         HFJzp8uu18XWOkqNscJmULjVMC+GNteFWjyVJ1aG8Kq6QsGiFl+6ZGWuHQ1zer8WnHrS
         z7WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BTJPrqrqSEwhgHq/Fq7SqerFqPYBOzBQre48SjGb0AQ=;
        b=CZlNrxEzqQ8CMkg8r0n9TGmbh4CdX9RtGVD5sV4s3gKJtXMCz/TQmRn2TcolEY/Ztn
         fOFGdBXpjzfP1msuhDV5xDROyYudOecbWj84swbPo/6pN1p/SRYd2mJS/qy5tqnC+GXk
         W5DII5Aq7oUT9uoiop8FTpwlQTwyAgNpYmh6bOIiIscDIlkW+jzaWM5pEVIDXEUUyXGV
         AtMrjWtLTh3lSbDG64kuLZOaHz4X0HR6KRdYUaoVC2R29TKhp8igTglbX1uQAUbG4S4V
         ublwbyliD1hUT4t7aWaAKx87srQ/bju8Kl9DtI/JYVmXVraamfkoqscSuRRD4yOutloe
         S0Aw==
X-Gm-Message-State: ANoB5pmJnmCZCMrxyzRsRW+s1egkmSx7AUwlWs3GuUTKvoiTDwW7dqW8
        yrjI95vcLLx+9+GH5qNq0VRTYg==
X-Google-Smtp-Source: AA0mqf7xphM5oz2jsApOp1Egc3rjQzspTFKB7OyQetps+UBwK7ZlkxAJ3k6ifjL4pknC+ROvb0Qnuw==
X-Received: by 2002:a17:903:1250:b0:188:6ccd:f2c5 with SMTP id u16-20020a170903125000b001886ccdf2c5mr10331527plh.6.1669225058240;
        Wed, 23 Nov 2022 09:37:38 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id j11-20020a170902da8b00b00188f7ad561asm1163747plx.249.2022.11.23.09.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 09:37:37 -0800 (PST)
Date:   Wed, 23 Nov 2022 17:37:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of
 error
Message-ID: <Y35aXX5b2Ed4vc6y@google.com>
References: <48505089b645019a734d85c2c29f3c8ae2dbd6bd.1668988357.git.kai.huang@intel.com>
 <Y3ySxEr64HkUaEDq@hirez.programming.kicks-ass.net>
 <52b2be9b-defd-63ce-4cb2-96cd624a95a6@intel.com>
 <Y30fUS5/JClpBHVc@hirez.programming.kicks-ass.net>
 <b3938f3a-e4f8-675a-0c0e-4b4618019145@intel.com>
 <da7ae78c2d9fed125f160744af5be75f34b1b1d7.camel@intel.com>
 <791bf9a2-a079-3cd6-90a3-42dbb332a38c@intel.com>
 <9f1ea2639839305dd8b82694b3d8c697803f43a1.camel@intel.com>
 <Y35IW/PnbxinKHOL@google.com>
 <168ca2b3-ffac-31c4-0b83-2d0ee75f34a5@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168ca2b3-ffac-31c4-0b83-2d0ee75f34a5@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 23, 2022, Dave Hansen wrote:
> On 11/23/22 08:20, Sean Christopherson wrote:
> >>> Why is it done that way?
> >>>
> >>> Can it be changed to delay TDX initialization until the first TDX guest
> >>> needs to run?
> >>>
> >> Sean suggested.
> >>
> >> Hi Sean, could you commenet?
> > Waiting until the first TDX guest is created would result in false advertising,
> > as KVM wouldn't know whether or not TDX is actually supported until that first
> > VM is created.  If we can guarantee that TDH.SYS.INIT will fail if and only if
> > there is a kernel bug, then I would be ok deferring the "enabling" until the
> > first VM is created.
> 
> There's no way we can guarantee _that_.  For one, the PAMT* allocations
> can always fail.  I guess we could ask sysadmins to fire up a guest to
> "prime" things, but that seems a little silly.  Maybe that would work as
> the initial implementation that we merge, but I suspect our users will
> demand more determinism, maybe a boot or module parameter.

Oh, you mean all of TDX initialization?  I thought "initialization" here mean just
doing tdx_enable().

Yeah, that's not going to be a viable option.  Aside from lacking determinisim,
it would be all too easy to end up on a system with fragmented memory that can't
allocate the PAMTs post-boot.
