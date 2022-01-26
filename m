Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F6D49C0CD
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 02:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235901AbiAZBgC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 20:36:02 -0500
Received: from mail-dm6nam08on2072.outbound.protection.outlook.com ([40.107.102.72]:25440
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235885AbiAZBgB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 20:36:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S0mfSRCVa8ijIupxUw7Ov9v6kDYz+Cnh4ufiQ9f4mZ8dyIZ7oDnmLPDWkcApka5vjrJJ0tTTEJxiWEySKYv3UmyLoOpzywIq44HBaxpfyYsWI5wyRomx/lThbjUZKTyaEdT+WKv4JL6Dg/SFuOPDqFyI4/NXm97w6iZkaKq1Em5wictcFwxypdZX7/L75I1XZo/FcrDrQl25n8p8v8X1eB8DUpBJJ9473aOHN4XbIOxqZDDk4ChjGHr8cip9fsMPRDWuFUNcSUk0EVtXHFQ3/tpBsSQxbOc1QIG3prTZv8YiIfA2Wrp99c9QJzhwHclcaih11L4nxvWFpgk42MdYTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+V/bwBhti14d1gyczP4hc4FQOPSRgHLldhbNUeTYX+w=;
 b=W/sLvDscfr+57R2xCsAxkEM6BlFMy2DlXHEuP40Br4HijbXSmxc0v4vSbHf8hQPjYTHjtIsWoNL7dWUhsd21OJgjJduM92cv3hMVUvocd2G0leS+8FpGK14He3eknnLIUiY9Yna/1GYIcN1CoHXzORm2mEH/z2GRA7L7XrauP2AWsAWQZNf7UU6GmVr/GUxLIvPeaBh6qbHjrWjI/cNv9Lj7xVMQuKCFRKKLyUd7TRvldBJGS9qI8jy7p8br+Tg+yMt+IQvZ8MWmbJdeqFM6EtTwH67Y8DEU5KilGR9xnNNBdfYCLUPPS2v75egObHSp4KUH/nZtK/Xq02mtRMXECQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+V/bwBhti14d1gyczP4hc4FQOPSRgHLldhbNUeTYX+w=;
 b=BymOZWREsrFoTQwLvKB3r0qngyHQoKU6VKXZuXFiJffgsouphTHBwVAU1fOxO5nc8j2RxYhE3hG5KfUhwB8eZHc/2+YiCU0goMtwAMJ5jvZ5I7wTN2AaHrAsFUlw1iASCesm3ztTZcTPOMVkOKN86etUH81DNyYU4fL1DHw8OEIxWrSovrA9W8BhyVQ5m1z1mxKktk47zF553j4qlux+46nSPzn8x17jIfUVNit/W5RcI2iEDrsNxc0DmnI1bXCVBKZB8PDxOh0PXHL0/EbHqdGOJRyiobYNEZ48uV3t+VOWYFe3hkBWopLTAGRuPK+hdWstRidQcGyIteNs7UhQpQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by BN6PR1201MB0196.namprd12.prod.outlook.com (2603:10b6:405:4d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Wed, 26 Jan
 2022 01:36:00 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::6118:6128:bd88:af7a]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::6118:6128:bd88:af7a%6]) with mapi id 15.20.4909.017; Wed, 26 Jan 2022
 01:35:59 +0000
Date:   Tue, 25 Jan 2022 21:35:58 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Message-ID: <20220126013558.GO84788@nvidia.com>
References: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
 <BN9PR11MB5276BD5DB1F51694501849568C5F9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220125131158.GJ84788@nvidia.com>
 <BN9PR11MB5276AFC1BDE4B4D9634947C28C209@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276AFC1BDE4B4D9634947C28C209@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR12CA0007.namprd12.prod.outlook.com
 (2603:10b6:208:a8::20) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b3c6022-4f9e-44c9-9fef-08d9e06c34e2
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0196:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB0196A2F4B7794EAAA5D2A2B5C2209@BN6PR1201MB0196.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mtO6ybMFaz7Fjam2PFj7j7PRzxxlb9dLSH35ovTJ61bUkQboIpUIJ5nYdrEtYgM3N+BETlFmvhrDq62rpRikUmHRqTA4DZIm68GmWZL3Gc4NfcpijPfnquZBxjWSG1pACm4lC268VdRPbyzoMOe+R7DLlo3a/f0/fiiue52dvODoOzu5tf+EPlXTu48/l7Fbh+f5oGK7ZX23nk9WST+Z/lRrpre/bK7Zb8wgdDmbaTv68NByql4XtTY7O2O/kVJY/px+jQobchRkGYdXjjsg+g5Cp0a2hmQbnuEEOuRFljorgaUNFLw+oBDnVpwInAsJCjgA8GbZlJr4hjGftBP2QU50CLfu5NON5HH38iBPBPZ/9T7J2I46B1eVJNZ3Dcs/1LqKMZ62hCA/6r4iNRHm6iFOKgQD9Tz01YIiv9RbPFtuNIzFYmI3kku4niWv9zF35DQ2xuy01eVvA20SLJU77vhCGAADH4C/aS4ipxBBEj0EQRt5aMuJ89SWh/Xkz22wzV2Gvg9y1M7jY8bmOz3NG90CLT4YPpGY6nsH/XUp2o082luILbKJEUtmQDYp9u6lQYGRhrgmpfZz/EcWRlKdXvuNFNCFhBXIZC4KeuLDX8cKmAkVYiW2nYbiuGTPUjpt79figD+rCjobxc6hRZ30zQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(5660300002)(54906003)(8936002)(66556008)(66476007)(6512007)(4326008)(6506007)(6916009)(316002)(558084003)(8676002)(26005)(6486002)(107886003)(33656002)(508600001)(2616005)(38100700002)(36756003)(66946007)(2906002)(186003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ggN18TPYilx4p08ibAxEQeIXRfDuszqNWkhqx+P3tbKnYZIN8aOmZswQZSl2?=
 =?us-ascii?Q?9M0LUcNVjBHWG8CE1cflDJUbXLgAxY8Jzd9J2zBkzZEbVaNbzmCO5knwNQir?=
 =?us-ascii?Q?UU78HVLg109jtpZFShZWhRlYl2Xqab5oBnxwGz+l2In4MEq8oWZ6ZYjDI2xA?=
 =?us-ascii?Q?WlyauSQF+NdvcCzjIOHdk4lqP2YWk+SERqLkhOww9H1IwTBVK3J0jxFAMuDp?=
 =?us-ascii?Q?r0SZdqDXWYV8X5FlJeMWDqIgaPSgRiV0gVVVtOhOHtrjChuYWheZO0a3zvuY?=
 =?us-ascii?Q?aTIjdDA3bkY+MWd+Riw27hgAA9HFax9+cDRaPLHGiL+ONPtneUGBScxnqvhD?=
 =?us-ascii?Q?E/PjUogalD2Lr5XEo7piSlkJqCRwX/OPHdXQFKO8lg0SKHj78kH072xawAhc?=
 =?us-ascii?Q?l7fcFClJzO1FAjbdQGvzYO2oXmkQiwhRA+S2lsactG/LlVyNSDrDHvqKcLcJ?=
 =?us-ascii?Q?5vKVbazMDZRzIfFuILymbY1b3OIAUKY/jJVdm2dbU/YOml4vXmC7m28OuQPe?=
 =?us-ascii?Q?jq7Xl/0RZ01sKRnbu8Nio1f06DJzdWTM0+2aLaZw9GOoiWdLqYlGnmXap0Qa?=
 =?us-ascii?Q?sTKbI61I1OOOtb9v6k4bugfBMtr73O/kOcmzrT8VdFwnMsjsaTz9nRmifGiM?=
 =?us-ascii?Q?8eSKk298TRrZy9Yhr2jyfoWmhuOQv1nTopD7+3jSnJ6+2c01P/JSGPHUgFoS?=
 =?us-ascii?Q?QJOoFgaGZhnk5qvDpSqt4zHNiHR9FId6gMaMexgSauGE+2Ydkf5NXOEI/lYm?=
 =?us-ascii?Q?5BRlR5IPLzFsS1gt4tyFbuX4RH01VEk7qLO6R/FsTHUCK14dOtafrmG2zCg5?=
 =?us-ascii?Q?/Y9KHjcEyINIGqAS5/RhnvXUePrVm8l8SqCuEUtQ+X2CNWWhhG7JXfi3rgj8?=
 =?us-ascii?Q?DSsNqPwJZwhrPtbnTuES5MCnkOMGYZQl1KpmvasOeYa6fjFew1Oe/Kjl4M7q?=
 =?us-ascii?Q?3pBVrFBdtiaR2WN+xNZLvmS6m5774oo/5tJSpKaoJYixxqcz+MKQ0jYzKPCz?=
 =?us-ascii?Q?U/9S8g0nDAaGi157WPiyaVaUJm9B6mCXu9bhzmOyxGsWonsbr0tuD/tk6Y7Q?=
 =?us-ascii?Q?wMq0mBMLL5FEEIuPup9YPDt0b9LawxmriU+MYPMP5GAbFWaMRR61T3gucSZp?=
 =?us-ascii?Q?RGmzaLgfFIDKX40wqGk3Ye7gVxLEqHQ89cgbp+yWo52XyCpET+cmmwLQyJym?=
 =?us-ascii?Q?wRuEiLMFHVzjRgKklZhoIPAFVJkbL6hpII/UwcehpUsvN5g6OWAAGtdg79A0?=
 =?us-ascii?Q?IjQAm2/qZQP0RXJtabQF9d/S3fh8oyNqEIXhW3wk9s/VSK9IjZGSeSqEWYuG?=
 =?us-ascii?Q?AEvo3LcFIAW/XgpIknK5/kBpqFruLVUV23q14Pc/rCVeS+wG0x6SuJCZE7NF?=
 =?us-ascii?Q?40cYnhNhZQCBzQMiNIBQyT4AlGD1b16U3IzZQPChlV5prIaFeT0xmhGQCv+N?=
 =?us-ascii?Q?hAeQVXts5NQUxIvHzh6d+bhiqHJVCDz6YJmr3v9xF5qOgeK5huz9+btQL+WW?=
 =?us-ascii?Q?q7SWybJxHI+4bbroG38pshzLJqQj5GvD2CIKpI7ROVyQPxvhJLejRWivWAcb?=
 =?us-ascii?Q?Ea58yV/jKDkOhFj4hRo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b3c6022-4f9e-44c9-9fef-08d9e06c34e2
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 01:35:59.8918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QGhDgH0LP+qeNh2dwvOd6hZt6W7p3gd7U7VN8l8oe0NV3pwTboU+l0jC6vNqkonY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0196
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 26, 2022 at 01:17:26AM +0000, Tian, Kevin wrote:

> Yes. We have internal implementation but it has to be cleaned up
> based on this new proposal.

Can you talk more about what this will be?

Does it use precopy?

Can it do NDMA?

Thanks,
Jason
