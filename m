Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87CB539E620
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 20:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbhFGSDl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 14:03:41 -0400
Received: from mail-mw2nam08on2085.outbound.protection.outlook.com ([40.107.101.85]:57025
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231327AbhFGSDi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 14:03:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n8qqHl56PYawTG9wPr7a99cT5vYsiuD+7FAIOpPucJ25OtPQaFdSRTbasZSVwHjBDZODnsomhgOZn8KXX7P1gkEiSM3dUwRP74gvB63/cU4MPG9f9rt9kRrHiWOd6aqstg+rkK04ylfTUHGggWGsfIM23Fg/JNAPdOe12MJqLUefwqPSwf7YOsgPkJN7k214iZynDAYCWpmosvGPs1fmr66PqXssOV0hyXDblNVMm5bIowegCnXziTs0nUTx6DUSI8uKVrKsiUIYL3hxQw16u+pA9/muIIp9FRdL4E4U9WznLUxp5jU/qW6k8ilYnSpFjmK0TyEDNPo/NyMfszyS6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YOzSkOnmNP9b5V0zth7QPbJ0wNH2CUEEDGufWNDHUm0=;
 b=ayX0Bx+lsOiBILvVQtLXWWW73L373yCdpY1HZrxT5ptnP4EK/6DK9Opeq3PAg1KdokXfHma+n496zG1jPwTYoSR9JJeLfQA9VTFv/lYFmOFVvC4nQomf3kNkxRBsNJXss7F+2V/mslSE9LWw+xa8PSFJhP9wLaKYAAQYdTXBcGQOFBMvQkKlXOHhpzZFSqFLZ7JBulpdCSpvV54fNxA3svAlZZAS6Sfew6/LwoNMIRzMCuiUhy5B/V6RH3pzT4lOKgfz66ogPhQyhZa9O/xdACGc2BHUINk53NNL37c9M4EtjwgKlir8CSwuA3l2nQTb8CoPfF3TA8vyPj/IeJ7b9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YOzSkOnmNP9b5V0zth7QPbJ0wNH2CUEEDGufWNDHUm0=;
 b=WuwjxjRLg+6hwA1MIIxVL/pjdMYMHJFQw2+LWu50sdcF4/cDpfiIStcISOu/NVLrTEeLwKJAyE+gHY/ZkFJo4R+BWuxdIfr0KXDeyTtsJajx+sR77IOypD9EU02wvB+ElL0kJpwcx4A28fkR0TXnZY2eZl9foDx5Qby6/xCY2dD1aHClP2R5VHxtmcafwL9YMw9XeGeQEFMWkcywKf5cWVlvwcvGvpu+Zpq3JTmjEqoSb0y++dUJYy37ob76jjQmsnkUX+A1R8fh7ms6JRpeUajQBQCHaECdcALnK8+PMfyFIAhB8VGKaVknmh0KiLeeD0ETrKubmW1m86NzHy4UNQ==
Authentication-Results: metux.net; dkim=none (message not signed)
 header.d=none;metux.net; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5223.namprd12.prod.outlook.com (2603:10b6:208:315::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Mon, 7 Jun
 2021 18:01:45 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 18:01:45 +0000
Date:   Mon, 7 Jun 2021 15:01:44 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Liu Yi L <yi.l.liu@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)\"\"" 
        <alex.williamson@redhat.com>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210607180144.GL1002214@nvidia.com>
References: <64898584-a482-e6ac-fd71-23549368c508@linux.intel.com>
 <429d9c2f-3597-eb29-7764-fad3ec9a934f@redhat.com>
 <MWHPR11MB1886FC7A46837588254794048C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <05d7f790-870d-5551-1ced-86926a0aa1a6@redhat.com>
 <MWHPR11MB1886269E2B3DE471F1A9A7618C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <42a71462-1abc-0404-156c-60a7ee1ad333@redhat.com>
 <20210601173138.GM1002214@nvidia.com>
 <f69137e3-0f60-4f73-a0ff-8e57c79675d5@redhat.com>
 <20210602172154.GC1002214@nvidia.com>
 <51e060a3-fc59-0a13-5955-71692b14eed8@metux.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51e060a3-fc59-0a13-5955-71692b14eed8@metux.net>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BLAP220CA0024.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::29) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BLAP220CA0024.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:32c::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23 via Frontend Transport; Mon, 7 Jun 2021 18:01:45 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqJZI-003Ont-IT; Mon, 07 Jun 2021 15:01:44 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef577933-3e5b-4635-eefa-08d929de5025
X-MS-TrafficTypeDiagnostic: BL1PR12MB5223:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5223DD286B412BCE557B727FC2389@BL1PR12MB5223.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /6wAb/H45IJwg/56AQ+u6U2XxVu0iMFlMv8aI8cgoCqnjiCTJb/197O2DG+mQC9BfCrIBmosJpZMyqj+SFJMdX6ZBfQCaPygpwM2e7XKow3cD6jF81p/uCGBBSr1eku8lGao/AOnW+Jj3dpQeywSMKu6chrZrZuZD3XERb6SpD831xg/IywV2xxXZnuNgpkFaxqZwQm4UQJNJ3UhM4I0GhHlzfFDayDmLZ1CkQyeOB545dSw1bzaWcAFXbn4WDxAV6cfbCQH6z9g8T1ER5Cd/9x2/l4Cc3obW1AITYHEqoEoSID637EwyMCUzAFsFao0hZ9/hsfkE7YqiJFSL8KVc4Gb21BV3FL1yCoCpotoM68ErA0RM/b/OPjUsf/HYo75hgHRMXBbhsmzL2Tr9y+YokGr/BSpEULkEg+GujrO00DJPkPAGc/5VYtDOV+klScw9ntMtUXND6B1uA5FHDf7SBS3w6S2yq+/IGsEz7qHe1oqVjmFm0c/L0pI3Nk++131rkuwi51WBRRJLHlM6WuuPXLAK1EmReNpVctR7z2dQoWd8UgooHIzNGoBmfI1aoavsXGnjKNR9HvoYPlIEDMUZZ9tf7R/rHYmzndfNQICaDk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(86362001)(54906003)(316002)(5660300002)(53546011)(33656002)(4744005)(8676002)(6916009)(38100700002)(186003)(1076003)(2906002)(66946007)(66476007)(66556008)(8936002)(26005)(426003)(2616005)(478600001)(36756003)(9746002)(4326008)(9786002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?oNji+EW8S2QSwMIfY+YHJeoWt2cL/Y6eIJr/3jqQE61aDvR1XGg9SwFpWC/w?=
 =?us-ascii?Q?o15M0UTWqsX2/HkNhy1RtniPi2IqhoMuCyPYpex06mpnLsLo3QK/8ynOsG+e?=
 =?us-ascii?Q?X6KnSjiaN3XbCFEtd7UYJGN2kNF2e/IHV6iqCKwxDw+cmPihqkF6ageCxxp3?=
 =?us-ascii?Q?ku+DJbUTxdUUPrhGasArrvR0okLhODdHIPLfLSXYG6mMWAcVcv8RDe6sMA7L?=
 =?us-ascii?Q?vTJBzudG1wiYfgFFe3IPOJ8Bchb+9Ryj9nRn6tPqDNKAo2GqJkcA+NEUsfqc?=
 =?us-ascii?Q?XJj/QrZhQSs/FxjoNLwgDCgJdgKTTWCml5in0fqianfez3FQAvXKd2KL3rnU?=
 =?us-ascii?Q?OuP3VjiwkQvbNR9JzsS5DA8qDfk1ncq5YNU9u3QndptBL4eAK/t8/x6paLFf?=
 =?us-ascii?Q?32sNGIhDQfv4xEfhtja08Pa8OyGLykkEuTh+aZL4zbkUn/UbsHD0MvCUvZqF?=
 =?us-ascii?Q?BPxDlkUMZpzmX2LTAIEks2FGBp1UkpJ/BBj2cv+FGs/c8O0hN3lIDtSEHoJH?=
 =?us-ascii?Q?uVj+n5T58XE8ht1begA9ed0HTLOKOUl5minj5KX9n2F6FV7XQyLA22mcobN5?=
 =?us-ascii?Q?2ruedtw2g8no94sT4sGn9lY3cLk89EDlQzWhOvJ1wAJAg6egTYy/TD6OFavu?=
 =?us-ascii?Q?uqn0ecpyofF+OOyczJzcV/kH/2zbUDgSCNFFU5qlclKOFQOFD2wluEUvRS+4?=
 =?us-ascii?Q?CqdE+PO1z9Z3svhMdgVorn72FhFYgrGR1HCPtb89KlhRo5dfVcplU5N1wk1V?=
 =?us-ascii?Q?iajxAZ1Ism0M6NxZ5NtPPuMrRQ6q/6Wd8QIW1XcGvYt35MdRNuI7bwx1XCb/?=
 =?us-ascii?Q?+oy5O6e3EZg6R2A/n2/Dtt/H8r4CjQ+Ule3lTByW558JxnyB4gnvGt8St5Xg?=
 =?us-ascii?Q?AUMPnROp5xM5ieNT/l+p5ElN66SdgTt6EzrzE/qa/NRaTG14syS+H/9Vv4rq?=
 =?us-ascii?Q?LHfzjl+z1Xu1Y9RBnNyyESRHeWjsm/nv3aMGClflWbZYNRpXxNG9PpPCWPMz?=
 =?us-ascii?Q?/+Ozap5CDQiOxpv8bVV/WgnnjxdrPui8U+eZ26GbtL9ExUn3OQxtxLrSPbUo?=
 =?us-ascii?Q?ZRalA1jlITIamCm6QwrCJbVyAsbPg8JOxJ/zXSzsqBpXaf03NF/AgPV6vxaL?=
 =?us-ascii?Q?8nyDCRrXtyJRtQdr+cD81qJl+HIHPDhbmNzCarmdwoxW2zm8vIbz6lupfrC1?=
 =?us-ascii?Q?Eq5o776knwdsRVe2/nuq0Of3RC5Cw2xDCxYiNkqyB5UenTq0QpUZYSWTCuqJ?=
 =?us-ascii?Q?VDW5MXjkeB6iPENPA3Ddlez29eOfxQPRQeb+JXQO+Y0bYm0y67Y6FjzlnDYS?=
 =?us-ascii?Q?13UQXxqtJWJZbPGVpoti8Crk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef577933-3e5b-4635-eefa-08d929de5025
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 18:01:45.5211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ugy34ynFZLBswzcfS4jQwDDrfJXZ1ipiimC7Jc3LP8DMEDr9P6Sc3oXh+BqSb4K6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5223
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 07, 2021 at 03:30:21PM +0200, Enrico Weigelt, metux IT consult wrote:
> On 02.06.21 19:21, Jason Gunthorpe wrote:
> 
> Hi,
> 
> > Not really, once one thing in an applicate uses a large number FDs the
> > entire application is effected. If any open() can return 'very big
> > number' then nothing in the process is allowed to ever use select.
> 
> isn't that a bug in select() ?

<shrug> it is what it is, select has a fixed size bitmap of FD #s and
a hard upper bound on that size as part of the glibc ABI - can't be
fixed.

Jason
