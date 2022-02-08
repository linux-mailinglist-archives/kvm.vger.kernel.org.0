Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 798A74AE3AF
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 23:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387350AbiBHWXQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 17:23:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386485AbiBHUks (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 15:40:48 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF5BC0613CB;
        Tue,  8 Feb 2022 12:40:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kgKMo4DG3VunHt7M/hSuOtk4fW6qnlV8C2KGjJUgKRRqK4XamDyQTn6r+eroDoVv+zCAhCT3Q0Yslw9VcCYqFdDdMYnjdeyIcFjY6Y5aRMKZ8G8YFRObFCsVj4HEaveja+v9my0aUxkoaq0RKFl+DUwsYs5bCgClavJ7jdDpAzO6lihXgmR3pQMk2m7bHZzburqbAZwLwZdojGys0EtrejsPXeoeBaVzkUaETznUNef9h1b/aOGTSffRXLDao6kCuOG9tF+AZu5XMmw9pY+kNunllpuNyPVkyrwXPhIcTMmT321O8pPNw2A2zDngcq6w+k5WDWy0zogM1ZdvGpNn3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lFdpFAKNe9KfAPzB0PPwX2WOvNXQA5Mjv4IGSVYqfY8=;
 b=mzCTF5Y2It4ausQJAg0wZBAreDh3MjQY18qIxMecZggy+3OBBXWPvqIjxXDkSPdr6G+ahliFAe5w9plDRDCLYldhaYaX4OXu7YU+79hOL2NM0s+CYfgH7DXMh7mVThB4BGA+Hl+9DXeZclhH+D1ynwcf9fyMrwapoSEMUxUvlVSdYnbLXBDpSv06ZIrZgv4fmFIY5fIYeb/wyaGbRk0IauogJpkNXMLzoaSZ0IVISS7R7qiLNZjnK4YAJ7W21Afdr2WEzo/hYdh7L3/Lx96epZ2UDX0HxIg0omXQeIlAEPj5pxbgKnOzgpcdMdkkv7D9ALlZPqX/8bsn3xotHurDnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lFdpFAKNe9KfAPzB0PPwX2WOvNXQA5Mjv4IGSVYqfY8=;
 b=sWr3N/2Ven9foKcwZymd1Z3xc2SyLT8N5RU6B8Ug/BQY+Ckp5pdulSVW1qdo3fSStw+DCojwHUpqg53fhHkL2wcw5X3TEUM0cyDL1JnoVstI/mz30oaLOlcsr/4u/tNxg6AYgUqkODUZHBCGQDc1aidhrddGsbAJzaIQ792SproE6abBy+Zvm2SNWO3JbSIlO4+qDik6ae8PNqbZHowLX39hm2wYg0KFd4A6Ksp+mYSZk5ScRFkxLbxv9u23vBYBcHhIsPI73jznDxGk73j/ksrXiOmEjDknXJddiMWeUayegECAUDPazVBfrpsMjduoae5N+EQWiSEsjPkERmhtKg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MWHPR12MB1325.namprd12.prod.outlook.com (2603:10b6:300:f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Tue, 8 Feb
 2022 20:40:43 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4975.011; Tue, 8 Feb 2022
 20:40:43 +0000
Date:   Tue, 8 Feb 2022 16:40:41 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        linux-s390@vger.kernel.org, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 24/30] vfio-pci/zdev: wire up group notifier
Message-ID: <20220208204041.GK4160@nvidia.com>
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
 <20220204211536.321475-25-mjrosato@linux.ibm.com>
 <20220208104319.4861fb22.alex.williamson@redhat.com>
 <20220208185141.GH4160@nvidia.com>
 <20220208122624.43ad52ef.alex.williamson@redhat.com>
 <438d8b1e-e149-35f1-a8c9-ed338eb97430@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <438d8b1e-e149-35f1-a8c9-ed338eb97430@linux.ibm.com>
X-ClientProxiedBy: BLAPR03CA0038.namprd03.prod.outlook.com
 (2603:10b6:208:32d::13) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9cedd7e5-11fc-4d7e-523a-08d9eb43468d
X-MS-TrafficTypeDiagnostic: MWHPR12MB1325:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB132557EDCEFF252CAF8497D1C22D9@MWHPR12MB1325.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BXyQHhA2aZ7IAMxituuG5W+493IgsWcT9deJOSXgJtC52zQy5q8PpxnZ52cEF7EhymFGG8jtpWF1Zp+0vLqJxSQvzmXzMjPNaIjSjv2X1w5VvWopl/rObrRTRGjuVr0yOehYbR90GHQ6RyL2vGH/rnU4/7I5PJ2yQJlz2cj3qntonxKzYDOtmnRVKycGhp2Il7KrzYs05UJD2vMf33EgEQtBPK3D9AgjGPx9rM6Izur7rlmd7sCag0QMPwOKpzeaP+eYMMmxIOU+vY8rt4T6/WGCcyZA9DlU7CeudCVIwOsW/5TuEm4TIYG9AT0fNURZwTzE7AfujwZVI4krBQ+RT6ZAn5bLPwhRtD5mswVZIUCoKKSNkv3Mw2g1TaNfkBJaXx9gE07MhAcehVmUR8jf+VB8HF5Bvq70OBpASsg59WAbB4Xam2p9F3liHwA0geLKvMGYKM/iZMXsG+Ng5BWjPMMKbW0EgWZAXhCuLWPe/cIu6knqLINkWJstTo284qELUcmqhhTIVoEMKb/LD6rlEOcCcp7v008/IYdsJD7jZf0RCN4RghDw7sD5+u+q18hA5+2KVyljvJ67ftw3NuUezLmEYYRUyEEPXbExTu0jmGhNiNzfwlQogWlmohZ34O8F8j/4AaDB+ca3kjiqar7v/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(1076003)(36756003)(26005)(2616005)(33656002)(6486002)(6512007)(6506007)(7416002)(38100700002)(8676002)(5660300002)(8936002)(66946007)(4326008)(66476007)(66556008)(316002)(6916009)(2906002)(86362001)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vNV3KfAcmTng1uYfTJRCclhr0Ib2KYg+JpxyaxThQ5JpJE9PaO3uW5sPKe5L?=
 =?us-ascii?Q?5li/0RI/qEvtySy9oAESt+CmBG1nT9D1mEnkSGghvOvEjDxo9WITJi5mKXGt?=
 =?us-ascii?Q?AbTE7BdcuoXAUUk8peMeKJjUwsbBobkvC1YHWz270VSMPxOiAhkKUWIA+uDr?=
 =?us-ascii?Q?tvEBjatb7qrc4G2CXUer0IIE9skF4vrTZ6XHeDSEJt16rHKkNne54idkz3m7?=
 =?us-ascii?Q?RHpS0uT2IOhCJiJrYL3IStlPxyUO29uHGju2q8rrWOj2sX/qbTiInq0n/NBL?=
 =?us-ascii?Q?Oe1UaaqGMlaTklv7bCaE0bkLh9XMm+OC58eSBEl//7ZCvmqX+ypmPXgDd9BF?=
 =?us-ascii?Q?fSmk1hgdDxK7iTRBlz8a9bT6vDxzzfouqZoH5bWV3KZhBJvvSsBJ3WFTutGI?=
 =?us-ascii?Q?gAM5FpaxFi3U/8ciM1MMd3EEQZZfJGU/AO+TrjLgcDoOQ0pmzobnYDIipfMO?=
 =?us-ascii?Q?4tj0MKo++9EN7NlOycrXKyVF6mGtofusiUpj7oIler/rCcT7tx4V2e+7Z5yQ?=
 =?us-ascii?Q?BoV8iI23FU5LdkfHipK0/x/szUlNQpo9mzgfqjd/jX8K0XoXkTysFCV1Wfft?=
 =?us-ascii?Q?tiu+T+3z5W3MDwpNWzHDwFRH8sZSq8FSICkLRliHklst5ebmy+q//FbjtAT5?=
 =?us-ascii?Q?5V1CHocGQVnePsD8t12dEfOzyp098zSU6y6wreHqnNJGzHkVUQ9+3zHbu1OJ?=
 =?us-ascii?Q?/6N81wZ3ATEsihXmbdY7i8JPC14SMbl+bjeKkax0dE3ndjzfFW2e4Mv0xv7U?=
 =?us-ascii?Q?qJi1u4gFIl/MK8nBhZSd/ZLcFLY/laiI9CHTvNRv5geYcYZEFJpt7hpV67Cr?=
 =?us-ascii?Q?28naWXRzMPjUIhNKY1/HvSoGIK6uuwUGAFoT2MVZkgVo9evHAS9O5QaqLrjk?=
 =?us-ascii?Q?D95mBZMEisbjBEh5Yvs3Xu0gdtR1gKNWhIg6ts0aWJNLj9ZBE5wUylNJxQmP?=
 =?us-ascii?Q?+5wVtJkrrm//ksS796p1sRtSjK+yjkTkCYjHzoVnsLRfkf8iHkImUQxN9Fxy?=
 =?us-ascii?Q?2T4QkJBx2thNs/zrpQqSbncWCaOK45fggjz6mbK/GAfiD+yEG4QY2tPEgQkd?=
 =?us-ascii?Q?4PQCWrn08saToI1n0xgO4YDcOpqHOtnGIHnnuHRDzBw1ZMJtv9q5kfUkiIjg?=
 =?us-ascii?Q?fXfELHKlq9+j2LMJuD+bDUDrONPOh7YyqeZBQl/8aTVkw3F/zY/eQfHtFMA2?=
 =?us-ascii?Q?bFx+Fi00gcIQ5FXdvgSE7pr2ftQRpM4cOZF9Ph9RsSLmIx7uYp0K/9RjDv5P?=
 =?us-ascii?Q?FFWctQBY5QU+mCnkxAmYWuGO1tFKjxwjlbw+16KGn476OwPE82kBaY8rfu4Z?=
 =?us-ascii?Q?SOXkFj9MVte9Za+5zEPRqa2DD2IRd6Rq4q5PnxGeDk/frDksNPzDrGmQ37Lo?=
 =?us-ascii?Q?Os2+1pDDSz4OgvZtUyO1JILvEqZOFNCTYhvsTloonHKWg0+VOb1WBsftTJX6?=
 =?us-ascii?Q?AkK3o4g8tSF57LGUSdlhCndKYtpCDGfUTzpWGXxGA8QTBujoO7f6rsOYywJU?=
 =?us-ascii?Q?oe6OcKOBThdTBPC5dxTJgQYCyauk69eo7xW6R/yMdPosQe8W+xxA671u5Y1O?=
 =?us-ascii?Q?qYVj79SYibSjR5iJmXc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cedd7e5-11fc-4d7e-523a-08d9eb43468d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 20:40:43.0826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3s+Nl2uKt/2WYajHGDM/vYhHi3W7GUZ6n+csoUH0BuR2NZv9KpCUqtusqF7+x4r6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1325
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 08, 2022 at 03:33:58PM -0500, Matthew Rosato wrote:

> > Is the purpose of IOAT to associate the device to a set of KVM page
> > tables?  That seems like a container or future iommufd operation.  I
> 
> Yes, here we are establishing a relationship with the DMA table in the guest
> so that once mappings are established guest PCI operations (handled via
> special instructions in s390) don't need to go through the host but can be
> directly handled by firmware (so, effectively guest can keep running on its
> vcpu vs breaking out).

Oh, well, certainly sounds like a NAK on that - anything to do with
the DMA translation of a PCI device must go through the iommu layer,
not here.

Lets not repeat the iommu subsytem bypass mess power made please.

> It's more that non-KVM userspace doesn't care about what these ioctls are
> doing...  The enabling of 'interp, aif, ioat' is only pertinent when there
> is a KVM userspace, specifically because the information being shared /
> actions being performed as a result are only relevant to properly enabling
> zPCI features when the zPCI device is being passed through to a VM
> guest.

Then why are they KVM ioctls?

Jason
