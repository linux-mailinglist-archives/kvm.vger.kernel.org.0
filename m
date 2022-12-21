Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9C53652F91
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 11:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234467AbiLUKfO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 05:35:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234036AbiLUKei (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 05:34:38 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D011FE
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 02:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671618812; x=1703154812;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UpN3dOoairOLaiw1OCYiapLDCGi/63LL0QBj+qmLuBA=;
  b=fB3IMplsh8RdfRyYzSu/4quN02vEFBqKh2xuqyhEAI8rDXVQK0NQ+cBz
   qdGmClkdfwUy9AElqGcvyd8zy/tZIQx06yG4oN5+V5t8Zal0Mlq0K171k
   /IVToRT5B+MuzwlPzojtK65l2xrsua/18F92/LoUufOGnnz92LznuwhH8
   R1lqYPRIJFzkcTmBffYzBrz4wQZP1NKiQA1Allf811oE29X6IOrA7+SQQ
   HD5Sbbw6vY3pssvL8BrwwMQpVgw8pfzg4P1GQZAN0ToVb8uDdTFIO0El0
   Dj6AgSfhjNeZhgrsOv8xzMFX+mmvoIqxeZgcghIhUevuR5TutQCRW/yuq
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="406080636"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="406080636"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 02:33:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="681988303"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="681988303"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga008.jf.intel.com with ESMTP; 21 Dec 2022 02:33:28 -0800
Date:   Wed, 21 Dec 2022 18:33:28 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Robert Hoo <robert.hu@linux.intel.com>, pbonzini@redhat.com,
        seanjc@google.com, kirill.shutemov@linux.intel.com,
        kvm@vger.kernel.org, Jingqi Liu <jingqi.liu@intel.com>
Subject: Re: [PATCH v3 6/9] KVM: x86: Untag LAM bits when applicable
Message-ID: <20221221103328.zdpatyf5bvmdyhsn@yy-desk-7060>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
 <20221209044557.1496580-7-robert.hu@linux.intel.com>
 <20221221025527.jbsordepwfytdwmx@yy-desk-7060>
 <99219ca2f5b0fdb2daa825374235a0b05b74724f.camel@linux.intel.com>
 <20221221093543.hq6lws77hxihgdeo@yy-desk-7060>
 <20221221102247.kvl6tkgd7vqqvztn@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221221102247.kvl6tkgd7vqqvztn@linux.intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

OBOn Wed, Dec 21, 2022 at 06:22:47PM +0800, Yu Zhang wrote:
> > > >
> > > > IIUC, LAM_47 userspace canonical checking rule requests "bit 63 ==
> > > > bit 47 == 0"
> > > > before sign-extened the address.
> > > >
> > > > if so looks it's guest's fault to not follow the LAM canonical
> > > > checking rule,
> > > > what's the behavior of such violation on bare metal, #GP ?
> > >
> > > Spec (ISE 10.2) doesn't mention a #GP for this case. IIUC, those
> > > overlap bits are zeroed.
> >
> > I mean the behavior of violation of "bit 63 == bit 47 == 0" rule,
> > yes no words in ISE 10.2/3 describe the behavior of such violation
> > case, but do you know more details of this or had some experiments
> > on hardware/SIMIC ?
>
> Yes, the ISE is vague. But I do believe a #GP will be generated for
> such violation, and KVM shall inject one if guest does no follow the
> requirement, because such check is called(by the spec) as a "modified
> canonicality check".

Me too and that's why I had replies here :-)

>
> Anyway, we'd better confirm with the spec owner, instead of making
> assumptions by ourselves. :)

Agree!

>
> B.R.
> Yu
