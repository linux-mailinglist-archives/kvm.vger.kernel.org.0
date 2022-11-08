Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8306216E8
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 15:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234084AbiKHOhi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 09:37:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbiKHOhf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 09:37:35 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2089.outbound.protection.outlook.com [40.107.96.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC642D2EE;
        Tue,  8 Nov 2022 06:37:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H78ugKF5QhuzxPhlcGESkvCafj1TE/oNsEX0PzAetRm2QEq23kNkw2Y6qVRQwbxHqFf0N3kV0HP4vt6mpsrWxwvAxkcKnJg7oI/mwzjQaiZXeBYk5CkVWb9sKpoqYPtx1yW+Lf4fLTMBntFHSR6SMc4g3nCxhpmGcJnZnTuDEUweovXfUMbyrY75p4aZOlxipyCA8IwGB7af7iQygz8DWq9IZ5CXm+0DDOPeXPMi8Dh2rsM4tt7MNZisLybnLf2iPmOtBxzkOz9yh7n/4ICukvXWqGEPsaoWpPi31G731V7Myvt7QvS9bjH84tk96GtusruFihQ/51HKQmtlirAAfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KM2FCplru/Lyn/4i91UoUNSKfnCfPNXzNZJECD7asOM=;
 b=LDyKOOCbc5FN+4IF2BfJ2uoZp5I23O29fLDlTPAgr89YhdZAb1bhAsKTGSWT2jAkcXdq65r0r+RO5Ao1vNnCU6We9MKKNfAaFvf/TOwBQi83SIzppQ9mUOr6cSWk+By1m5cT02KJGa8NVXMvdue22KPttlMyY5s24RwpFGRrxyGEF5BEymGq2kTJ2EkXsy8C8kJ6GeQtD55BkfhUfOnezGumgWvtpV+76MZfJ7RNnzKFscr5K956+5BprHSLtrT/rD9L6ABM5WCjIrPJG+X49WndTAWa85DCUVMNqHXlIiiOXZMJLNKU+mBncwiqlV8J1ZFgMPK2iLQUcKp+hqUSaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KM2FCplru/Lyn/4i91UoUNSKfnCfPNXzNZJECD7asOM=;
 b=pBesr2C3tOAfuTu1AhvoVLA023IgL6uBjA2UWbazwRbs04LAuSQ0NVXtOTJnB+GE2RZqkDjsMsoL7BgxYgGsm96iacECA7mzKDdWEMbRi5ggO20i+rEMd+RNCbmPetF5ZLWVYyIGrtF7c9AUt98se9JiLVBR/CYTy6EP9z7Ev7X+9ckKeFqqmnJ6vk2mfhcajQZ8LgJ+xCONth4ZS6DrpEYQCzRv4Dme3Ix+M6m4ARWn9vfdrbFO5lpZ2KgiWJYmd/hKekyF6i/0CESSNoyqYuhfXmb4rQPEudvKs8SCkNw7h2bzQQq5zKGQeWDj2j5hxcSSD56YYDdm1BfhyYABmQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL3PR12MB6451.namprd12.prod.outlook.com (2603:10b6:208:3ba::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.24; Tue, 8 Nov
 2022 14:37:33 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%6]) with mapi id 15.20.5791.026; Tue, 8 Nov 2022
 14:37:33 +0000
Date:   Tue, 8 Nov 2022 10:37:31 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: S390 testing for IOMMUFD
Message-ID: <Y2ppq9oeKZzk5F6h@nvidia.com>
References: <0-v4-0de2f6c78ed0+9d1-iommufd_jgg@nvidia.com>
 <Y2msLjrbvG5XPeNm@nvidia.com>
 <c32829c8-1259-7441-f6df-04f44a39ab2f@linux.ibm.com>
 <Y2pffsdWwnfjrTbv@nvidia.com>
 <67dafaf27cc029ffde1f7c474c2fd17907958d5a.camel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <67dafaf27cc029ffde1f7c474c2fd17907958d5a.camel@linux.ibm.com>
X-ClientProxiedBy: MN2PR04CA0025.namprd04.prod.outlook.com
 (2603:10b6:208:d4::38) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL3PR12MB6451:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c0b78c8-e5eb-4074-a3cb-08dac196c56a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4HG0BpFIyr++Q59oo9dwOI+SmxR/OBkxdY/ZhHuOGwnlV/IEyQT36OBnZZ0KTQEdbhI7mVhdmoHwqGagOIqnlRs608zBIR2G+fN4ixRNuUGrf9VDSzxa9l6qmE0RUZMkKLggYauYQzgegbRHhNdctAF+//2Nf3FS4L5p4ax0JAK6QOuCn8XRBzK7LV4psHbsPtcWsIZsiBPna+4gDbMaxGl1DxPYUzCyJ883X5XZCefmV7HLB2QzTJwftvgEVctPTIE+xKbu7nespDcAbX//Q1JvP+Osie9XHvslCYpBBDh+HR9eOA50mhyFTbX4OC/M4I8I7CmFHIayKZe4X/yoSlQ8bx4+JFJtCtIhqvf+4I/9p7/2l/DjhFs8irDGM//U3qMxpJO0QqS4gMR0TNj3ENp4AU7c08iagKeHpJY2YHyMlr5zPFOuSs58T32A3aIcHBrLBooKcXRVjZBxWMt3XvprRBQg8/OmOD0kse24G7Q2++d/1sRnaMwS/LeP9H9Clpbykq5u/d4RV7V3Ak/BeTEPiDlyxFiilpcv8y1X6UUTe3YmiwSvACeC1ODyIJamRWPQ8xWj5Bf+LbS3O3kG3RGkxBDA75J5yWqIx5uIkBwAYWY7LYMx2Rd+oAXQAXbYUXT4Q/xVqvgLT2uCCH9BQaBrzzmPUYSR0JD8y1qWDAo2gJVxCrEi/orw6Eb3KVbdcO/rc+lDE5ByPbP09CEEGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(136003)(376002)(346002)(39860400002)(451199015)(36756003)(86362001)(38100700002)(7416002)(8936002)(66556008)(83380400001)(26005)(2906002)(107886003)(6512007)(6506007)(41300700001)(316002)(186003)(66476007)(6486002)(66946007)(5660300002)(6916009)(2616005)(478600001)(54906003)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NGNnTlpnZ25vSGkyY2kvNVRlR2JoUDcwR1lTUEdzbVc0Mnh6YXhrb3VNdGJW?=
 =?utf-8?B?ZjB1dkpaQ0g2UThZa04vRlBwdWxZRExFaXhGbnZoNXJWd1pIZ2c3MWNLZ0o0?=
 =?utf-8?B?N3lxOFJkMHlzRXZoVTdiR2dXRGsvTFlvcHRLbnJkZ0J4WGgyaUVCNU13TU1Z?=
 =?utf-8?B?K1F4ZGVqMWVLY3RySW96NGlRYjRQNktKQTFpeE02bmFteC9wRFByclpza21Y?=
 =?utf-8?B?RDRuVGNVQkdKSEFRMnRGMkMxaHR4Z1JPZnZjaUEzMlVoWnY0MlRJdHM1bEFh?=
 =?utf-8?B?ZVZGTDNKaGtBVXVaWWFkNFVuSTRpMmdRMFpBcGVkOXRnVWVYU0lPL0lUbGJK?=
 =?utf-8?B?MHgySkM0eFdqdDBtUFN3WHZuQUR5eHkrTUVzckM1U0hhSDEzcmw2WXdBano1?=
 =?utf-8?B?dWxBMFhENXE4dXBSTHQvWE05WTI3WjE1ZXQxd0ZWUzNSQXQ4TU12SVVscHdE?=
 =?utf-8?B?YXUwRXZybHNxRzBvUjd5LytYNExhMllablNzYm10UkFKeVVQeXhYbDRnOXF3?=
 =?utf-8?B?eEEzeDVxbUVTemR6TmR1WmNwSUsrK3JGbHR2Tk10anJKZDBFL09Ha2FVQ3NX?=
 =?utf-8?B?ZHF3NVdRUExpKzN2eWxHMmJiVGk1N0VQOHZXKzFhZWJRc2QzUGUxWGpzQnRV?=
 =?utf-8?B?UXViMGNYZTRwT0xzU2U2Y2M5M3pxZkN0UTYwOFBIRzhLc0ZFUkxlQ2dObmJR?=
 =?utf-8?B?dmRKZDJXWndESDdDaWdSVThIejR6VVZoTTZSQmFQUkdUR0VxZzNZdUJubkx4?=
 =?utf-8?B?ZCt1T2dmQTRvWkg3U0lTeHNMajZLYUJxSGQ2RW40TnhrNGxLRnd6Nittb1Ro?=
 =?utf-8?B?VHNRZEw5emtOZkdLaCtpMXJFclk0NzgwRHczMjA3NmkvMUNnRjhuaWh3ZEdm?=
 =?utf-8?B?YVVKVzBSMlhsaWV1bEJaWUZ6RHdmMlhteUlWci9IaStNVmNYdmhpZm1pRk5B?=
 =?utf-8?B?YmtQV2lwNHkxUVJKdmRIMDlsc0VxMDcweFlHSWZ2cWJQRW5JcVRlR25TcmUv?=
 =?utf-8?B?dGhkWkZCZFNveG9KWmxvZVh1SGlNbm5PWEJpMndjWHNsRWV1eStUUDVzZ0Na?=
 =?utf-8?B?MmFFV0p4eHl1Y0cvbG42L1lEdzhkSStTaHR2b3Zrb1IyaW8wR0J2aDZwN0Fx?=
 =?utf-8?B?b3NlUTZ4MHRoL05FRVJOMWdKVlF2NHM1UUJERkZhNnk1K1RMcUhwTmZsVk5C?=
 =?utf-8?B?RnpoYXFJN3JSaFBrT1hIRllKQ05lME9QK2FMajBQRjF1MmZrd09UbHhySzBh?=
 =?utf-8?B?R2Y5aFdRNllrR0YyZlN4SDdvK3VqU3lSbjNMOTE2Ly8vcGNjK2pNRlBtSzhs?=
 =?utf-8?B?eVFmQzBXR004bStKTzNQR0lnWjdaZkd0NDdvc3F2VmIvbi9RWG84TExvWVRr?=
 =?utf-8?B?Zkd0ZGk5cU9HRzNQN1FwNXdEZU00NVZBdnM0OFE2b2hLSVp4bDJhME1ySHpi?=
 =?utf-8?B?MUZpaHVyZWc2bktaL2NYeVVyVzhuU1NESjVTbkFSUC9wamVHekZ1MktDUlQw?=
 =?utf-8?B?ZHhYc09FTEdDMHVHQ3hYR3FQUzRtRFZzL2toQUcveG14MEo2SUtTaG5JTWhZ?=
 =?utf-8?B?QitMNzJHOUlBcisyV1FUb0t1bkx2QU5CNVNuSTIwdUo0bVQ2TnUzOGtsUEQ3?=
 =?utf-8?B?b2tDYm1FSDB0VjdLV00wR2pTSEo0M0xxTVVheFJtMUxrQmRSQ1BpRGs5dk1q?=
 =?utf-8?B?cTZVR0ZEeS9aWk5HMTJLMGtKbGR2dSs4TE1MZm1IWG16a2ppVE4rVjB2Q2dC?=
 =?utf-8?B?K3o2NHh0ZGN4L2c5TEpNOE9LWDlyNEFIRWk4N2JCaTI1OW42R1A1dEJrSGxF?=
 =?utf-8?B?MzdGK01sMlNTNUt6U09rMStrTHNIQy8wMFg3SHZtZ1UrY21UL2Erd2dVTDFD?=
 =?utf-8?B?RVV6V1hMUUxTa3NBdkY4U0ZpckNvOGEwQzlza0J3dzk2cjlpc1pBK3IrN3I3?=
 =?utf-8?B?MFMyMTlZMDhjZHM2WFZZNjd6eHFENEtaYjNsS2pub1djUXVMa0tJcjkxUDZa?=
 =?utf-8?B?Zktma2VHdFJsdXJrUURoMGxiQVR6MWtpNEFrejlnWk1rY2QwNXNCTUlBWWlR?=
 =?utf-8?B?c0VvWU1lSEJoWjIveEJKNHpVSS9YVUpUNVQvNlhnUXN6bkc2a0YxNThLallV?=
 =?utf-8?Q?Wmu0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c0b78c8-e5eb-4074-a3cb-08dac196c56a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 14:37:32.9434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gne8O0KfArKsEyUZ1q5m9t9C0aAMAKr1LQ/cwi7c6k/S8Z1vnvPZ27TJZhxsLKDA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6451
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 08, 2022 at 09:19:17AM -0500, Eric Farman wrote:
> On Tue, 2022-11-08 at 09:54 -0400, Jason Gunthorpe wrote:
> > On Tue, Nov 08, 2022 at 08:50:53AM -0500, Matthew Rosato wrote:
> > 
> > > FWIW, vfio-pci via s390 is working fine so far, though I'll put it
> > > through more paces over the next few weeks and report if I find
> > > anything.
> > 
> > OK great
> > 
> > > As far as mdev drivers...  
> > > 
> > > -ccw: Sounds like Eric is already aware there is an issue and is
> > > investigating (I see errors as well).
> 
> I -think- the problem for -ccw is that the new vfio_pin_pages requires
> the input addresses to be page-aligned, and while most of ours are, the
> first one in any given transaction may not be. We never bothered to
> mask off the addresses since it was handled for us, and we needed to
> keep the offsets anyway.
> 
> By happenstance, I had some code that would do the masking ourselves
> (for an unrelated reason); I'll see if I can get that fit on top and if
> it helps matters. After coffee.

Oh, yes, that makes alot of sense.

Ah, if that is how VFIO worked we could match it like below:

 EXPORT_SYMBOL_NS_GPL(iommufd_access_unpin_pages, IOMMUFD);
 
 static bool iopt_area_contig_is_aligned(struct iopt_area_contig_iter *iter,
-                                       bool first)
+                                       bool first, unsigned long first_iova)
 {
-       if (iopt_area_start_byte(iter->area, iter->cur_iova) % PAGE_SIZE)
+       unsigned long start_offset = first ? (first_iova % PAGE_SIZE) : 0;
+
+       if ((iopt_area_start_byte(iter->area, iter->cur_iova) % PAGE_SIZE) !=
+           start_offset)
                return false;
 
        if (!iopt_area_contig_done(iter) &&
@@ -607,7 +610,7 @@ int iommufd_access_pin_pages(struct iommufd_access *access, unsigned long iova,
                        iopt_area_iova_to_index(area, iter.cur_iova);
 
                if (area->prevent_access ||
-                   !iopt_area_contig_is_aligned(&iter, first)) {
+                   !iopt_area_contig_is_aligned(&iter, first, iova)) {
                        rc = -EINVAL;
                        goto err_remove;
                }

Jason
