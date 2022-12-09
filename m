Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7006484E7
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 16:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbiLIPVR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 10:21:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiLIPVO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 10:21:14 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2079.outbound.protection.outlook.com [40.107.223.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DC086F69;
        Fri,  9 Dec 2022 07:21:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U6pNOhCJdENoAx2FnkZQfwmRARMBXJ5zgcpkOx/0mHPAxt2VNltuPKdVTnF4l1SJDHnHDHnTYEHy0LvsMEhINjgvR34Xlr1oJFl1TxnW6F+wtVohdq/wSrCiI7fgEEodAaCvn0+QTUvPoklStnq3X3HCVrBQIQnD5dwkNS6n7MZzbBMuPTx+izi5wlsIXymfXLV2vjBYk2ciDhjSYx+l4R5RxauEmZuT8/mxrJ4tXe2uuQcm9ds5U2zDzZl9lApl/Ii836YKpyyMlKpUAQ9TQURqUEkOJ1p46BiW1QsC8i2bW8GHrkHKCF8TykxxuU4yAdG1kGJzD1D3pWx61dOMsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0fKNZrTiJK6sF+/nFTZPPWHEoDMF6oDjOr+9jaiBv3Q=;
 b=DHUmmlssreJ2sz+1iACEXOsyyNg/BpXeHcEGj23N3zVOBAgfvytySHs87cOtNXscR4UOa70Iczj5LRfVTEQc0GLKZdOcCy/dDDv9yOaxUhjnEa1UW26jMub1ePrKE0FSUUDqQyRTBBgkUhbqA4mKYCfd44Chl/ZJAUgzTvY5DLFRE+E56vVkP64pFMm5tZth1nGpKw/Du0u/jxPecYp93RvrTJj7DOsa6xOHFlan5HvKoFu3PZ+bbWh3zeZd8xMz/q6GSF62p5vpjMt9LfEiOt38OjpdxBW2//j3nTaOynlE1Iy1HXRToBDZKSoO3wrThrrJeWITWcrH/gWULc4Bkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0fKNZrTiJK6sF+/nFTZPPWHEoDMF6oDjOr+9jaiBv3Q=;
 b=SMyrcFQSGY2Uo+bk4vHp2B7SRmgADTnNN6Dwhh9lqk9dTygmzhgyhu0iE4vr4hkngRbgpEL0G9fhJO4LiQrxPv/H6mEyp7czsIfsL1nRx6Dp5TxAJ0MXPSKc144Kx15XE2vi3DM88hAxVEPuSBRBFy+DFROID3L46GtF80CY5DJDJjWYdOwVKlXgaxKCMcC3Zv+34ysjsRnwnctb2lP8kIoHF7on0ijO5Zth5PeRIXW/EM9MnkbQ5fLZAn7WH82a/4p3zvw/hpWAuxTich8MVssTUXb/Iuu5RXjdp9hfwcXa8PhExH0g58nEGFULOEIJpQm2YLVTK1s/xGn37THMYg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL3PR12MB6641.namprd12.prod.outlook.com (2603:10b6:208:38d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Fri, 9 Dec
 2022 15:21:12 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 15:21:12 +0000
Date:   Fri, 9 Dec 2022 11:21:09 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH iommufd 0/9] Remove IOMMU_CAP_INTR_REMAP
Message-ID: <Y5NSZZzaMAgV5HSe@nvidia.com>
References: <0-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
 <BN9PR11MB5276B4F1DE4D31CAF8ADAC408C1C9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y5NIZTKqtlzVeNMJ@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5NIZTKqtlzVeNMJ@nvidia.com>
X-ClientProxiedBy: MN2PR13CA0015.namprd13.prod.outlook.com
 (2603:10b6:208:160::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL3PR12MB6641:EE_
X-MS-Office365-Filtering-Correlation-Id: 45b01d83-3b51-4535-fd1f-08dad9f90075
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cu5Wy+H68UtxpkjbHRY5+zV1SJA+0VfFF9I97g9ccncbxvzdyZs3Yzzpy6nYWMKp5hcYuKBljGVSZaaqdyCCukc5Rrhnr3VW/WWuodeDtosuyAbZTmH1EoqV2HKBJw2T8Wk4k9Ah20iV2hMtNQWdVsK4GlyaWlOcFO+I64jfdDKmzwv5X7ucTyWJme/2gLov0t7lGXvfV9Ss0yaA/SFr7KXvM+VA+YyU6MB7QGVTEFvRwVETgdWULCPG3UAZ18Z8GYC5f0krsvGgZJAWzIq+0brm3fiZYbvRjHIenRiqWTtFGk9MuHcmNtLWryjmD9t5mOxmbnVpeu+rzRDhR2igFeS8Cs/CR5a+K7Zsmmr8P6lWGtELQ83Q5O1C6jB5uk5qSuJbiNuvAFnSb8R5RjkGofmjCxWQPatNRAnZDCjW0cm6fSpssh+toEkEy0iX4yo0+nWemiqy0uRmLOw/nyxZ40DO09zTgKOfgNo1TzXa/LD0F+j+/y/KC8aeb7PiU1j/1Ju82q4n81pmYydZhsLBA8lmoIe+Ml4Re8dVHsYHpSg1nmjW7/Rzk5TBBZwro9XvM78h4ktcOVDJCFWcpq/OCRopQdVJxOkPg0+iA6iky1Jg2+X0OnwMVn/nJ6PY2+zEQ9skH3fbMcs2vZ9ls1Gcgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(451199015)(66556008)(316002)(6512007)(86362001)(478600001)(36756003)(26005)(38100700002)(83380400001)(7416002)(6666004)(41300700001)(8676002)(5660300002)(2906002)(8936002)(6486002)(54906003)(6916009)(66946007)(4326008)(66476007)(6506007)(2616005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6EFE4qF/YEr3NnGcwjwsENdMZRtkr6bktNL8Ne8w6R5WoCtRvzTrOuZbUbM9?=
 =?us-ascii?Q?qvyWjt1bQ708vJQuNchYP/ZIfgpA49dcHISMT4usP4mgtEdl1tkosrN0WQy3?=
 =?us-ascii?Q?gGdwSFpEmDtj/R+36eLaQ8KskEMS26tQaCj+ByXYgRoIhNm7rRl49kOQCBi0?=
 =?us-ascii?Q?C4fvFgpdsnVi3lpZtjjtPGgaxySVoP7KrO2+rXCle/yH2Nd3t0Z8CjQz1ij8?=
 =?us-ascii?Q?H3YR30vHi8JwSY2XUV/6Iwb8rARzTyLKLfiFcW6DNYXTcf1eft/63IjImmzK?=
 =?us-ascii?Q?AshgE8xemFBX8orbLu84EHnR8w9Wy1PD55TdmFhkoIjjN1ZlweEgD7hnDpc7?=
 =?us-ascii?Q?sjxQasd4nVo1VxhZdnrpOqvtJUIzo5MqU/RnmtdCg0BPMCg5cHZZoIk7PmRk?=
 =?us-ascii?Q?lQ4odYhG1bYCx534ASESH7wMaZfRVjW/RiQ2aQ8sVNSahhlqG900lLIajdX9?=
 =?us-ascii?Q?pq39G5tYKroqHXmNgfa0bAlqE4PR3+4HbzwNIFL1a9snstBLNbYdIQld6W1q?=
 =?us-ascii?Q?86wSEASht+TTRs0uVy2qfGphtSuwvrkVTIzmWC8OvrFV3SkLsDu1KsAzdi6I?=
 =?us-ascii?Q?UT80dHImwbGdqJEWUG5KJ86efcLfbUuJCHPh7ocdzdzkERNdxYy+m8SVnTNy?=
 =?us-ascii?Q?hC0fZFoXds9SQiem3vjbPc4ASMolN+9pk+OKUIMbloxf7i52Kvb3hsOeZXVM?=
 =?us-ascii?Q?+iOEG4LSowIFC7z31yskv2Jhj5hKHvdB+RSxEaCyRNfIrbtyZuNYpBae7jcV?=
 =?us-ascii?Q?JbVd7kIe7g1492IkXEF/PJQZ+b36CU/z0C8LDlZG+zbMzLPGJUVl8lPnMBDZ?=
 =?us-ascii?Q?6XmwRkJNrZDH9TdfYMnfVcUpZV4tZc7QPHsTChLnb3eBXt48gmweyvvOuNAd?=
 =?us-ascii?Q?O4CbN8bdFhggtlW/3RZnw5Lz+JUA2WQ75gBkNIF12WI7gi9anewtgT+laYDP?=
 =?us-ascii?Q?r2p9csUadm9wiKtYIGfn+c7nle6BpmWbGDTYU3VaxMeLkPynAA07k8VhRkOY?=
 =?us-ascii?Q?oNIX+V13reQfdGro6ny/VtGP5NwXlAKC6QU5b941BWPA+mir88aFJAIZDGlG?=
 =?us-ascii?Q?5a3q0hEp6zdZ2qX0+MjMTs47M/+qfJ1hm/BPzrrYGpqUS5yqeFXfiTBmJrgY?=
 =?us-ascii?Q?/6SXIVBmtK3zOKCkDeXbD+bl/n1Q4V8UjgRC8A3loD00vbj6+NEvmvGUyIdp?=
 =?us-ascii?Q?gqblzAEADWFvRNVKP84gK1utRJG75pj8V5cNhI4xjfUSWlM5PmUEg1sTx/Ai?=
 =?us-ascii?Q?iDZxJ7PgY1khhSRB/NO7yt69zu9CJKryKGc/tZ0x8ZY6yZ5Eoz0G1/2dIbBp?=
 =?us-ascii?Q?wujhAzlLzjCAJyzyznHsa3tthvzGENdBvJeRZElnMC9yeDawBXQZY2gJdSc5?=
 =?us-ascii?Q?BZd9dy1QSYlYsdMHofgNfq2ymL1Q+RtT/xBWrAu5UA30p8u3kVscI88Bt9lH?=
 =?us-ascii?Q?Fdu7F2hxHLZHmfxhL4SkMIPrS90XcYIdOEbJ0H2TycOH1dn8NxT9urftIVyT?=
 =?us-ascii?Q?LPrru7SLU1AeC5BOCKdNFeUT8nm3/8AN3DiQvUWlTb66ZscZ38qAqjE7qn4N?=
 =?us-ascii?Q?KZU29tsZm/ewnROw5lE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45b01d83-3b51-4535-fd1f-08dad9f90075
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 15:21:12.0437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1fg+J3qSTt0ng5WfvzlJFhAlRqsgBKP+SwSptt2Yj5WaivKzBsQlu2ilfa9Cj57C
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6641
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 09, 2022 at 10:38:29AM -0400, Jason Gunthorpe wrote:
> On Fri, Dec 09, 2022 at 05:54:46AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Friday, December 9, 2022 4:26 AM
> > > 
> > > In real HW "secure MSI" is implemented in a few different ways:
> > > 
> > >  - x86 uses "interrupt remapping" which is a block that sits between
> > >    the device and APIC, that can "remap" the MSI MemWr using per-RID
> > >    tables. Part of the remapping is discarding, the per-RID tables
> > >    will not contain vectors that have not been enabled for the device.
> > > 
> > 
> > per-RID tables is true for AMD.
> > 
> > However for Intel VT-d it's per-IOMMU remapping table.
> 
> Sorry, what exactly does that mean?
> 
> Doesn't the HW inspect the RID to determine what to do with the MSI?

Okay, I get it:

 - x86 uses "interrupt remapping" which is a block that sits between
   the device and APIC, that can "remap" the MSI MemWr. AMD uses per-RID
   tables to implement isolation while Intel stores the authorized RID in
   each IRTE entry. Part of the remapping is discarding, HW will not
   forward MSIs that don't positively match the tables.

Jason
