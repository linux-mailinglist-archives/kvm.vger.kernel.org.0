Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44ACB21A674
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 19:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbgGIR6g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 13:58:36 -0400
Received: from mga03.intel.com ([134.134.136.65]:23876 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726615AbgGIR6f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 13:58:35 -0400
IronPort-SDR: aS+QJROa/Ug7rUY1ifeOg6srILqk04JhVAOwOIwPhOb1JA42rIeaU5wTADepgKSm45RfgNA/pZ
 fJJF8bGXGyaw==
X-IronPort-AV: E=McAfee;i="6000,8403,9677"; a="148055029"
X-IronPort-AV: E=Sophos;i="5.75,332,1589266800"; 
   d="scan'208";a="148055029"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2020 10:58:34 -0700
IronPort-SDR: Vb+OfmhMj2iAtUuI5rG8sMS5Hw7OJUYKMj5Ms5QowwyyY9kueZtN3L7Pqgob/yZounxzyaJcHu
 zwZP6SaQ5daw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,332,1589266800"; 
   d="scan'208";a="457995504"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga005.jf.intel.com with ESMTP; 09 Jul 2020 10:58:34 -0700
Date:   Thu, 9 Jul 2020 11:05:13 -0700
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v3 06/14] vfio/type1: Add VFIO_IOMMU_PASID_REQUEST
 (alloc/free)
Message-ID: <20200709110513.3ff50f99@jacob-builder>
In-Reply-To: <20200709082751.320742ab@x1.home>
References: <1592988927-48009-1-git-send-email-yi.l.liu@intel.com>
        <1592988927-48009-7-git-send-email-yi.l.liu@intel.com>
        <20200702151832.048b44d1@x1.home>
        <CY4PR11MB1432DD97F44EB8AA5CCC87D8C36A0@CY4PR11MB1432.namprd11.prod.outlook.com>
        <DM5PR11MB1435B159DA10C8301B89A6F0C3670@DM5PR11MB1435.namprd11.prod.outlook.com>
        <20200708135444.4eac48a4@x1.home>
        <DM5PR11MB14358A8797E3C02E50B37FFEC3640@DM5PR11MB1435.namprd11.prod.outlook.com>
        <MWHPR11MB16456D12135AA36BA16CE4208C640@MWHPR11MB1645.namprd11.prod.outlook.com>
        <DM5PR11MB14357DC99EFCDE7E02944E2EC3640@DM5PR11MB1435.namprd11.prod.outlook.com>
        <MWHPR11MB1645F822D9267005AE5BCE528C640@MWHPR11MB1645.namprd11.prod.outlook.com>
        <DM5PR11MB143577F0C21EDB82B82EEB35C3640@DM5PR11MB1435.namprd11.prod.outlook.com>
        <DM5PR11MB143584D5A0AAE13E0D2D04B7C3640@DM5PR11MB1435.namprd11.prod.outlook.com>
        <20200709082751.320742ab@x1.home>
Organization: OTC
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 Jul 2020 08:27:51 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> > So I'm wondering can we fall back to prior proposal which only free
> > one PASID for a free request. how about your opinion?  
> 
> Doesn't it still seem like it would be a useful user interface to have
> a mechanism to free all pasids, by calling with exactly [0, MAX_UINT]?
> I'm not sure if there's another use case for this given than the user
> doesn't have strict control of the pasid values they get.  Thanks,

Yes, I agree free all pasids of a guest is a useful interface. Since all
PASIDs under one VM is already tracked by an IOASID set with its XArray,
I don't see a need to track again in VFIO.

Shall we only free one & free all? IMHO, free range isn't that useful
and not really symmetric to PASID allocation in that allocation is one
at a time.

Can we just add a new flag, e.g.  VFIO_IOMMU_FREE_ALL_PASID, and
ignored th range in free?
