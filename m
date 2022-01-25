Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 197CE49B4B3
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 14:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385395AbiAYNOl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 08:14:41 -0500
Received: from mail-dm6nam10on2040.outbound.protection.outlook.com ([40.107.93.40]:50656
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245176AbiAYNME (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 08:12:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bAeEVgARFV8mOsSaRKmSeXMJ+7rwtuoqHZvefvAZjeYeBUJmbUJY0A12aagR3fXVwn2a0TbKql0BBevEPNFABMzmgb866I3gC3vD3IIdH5EfUH+TFPt3DS/aA+lMiIeigwz3/T0eQjC45mrsF3gUIP17ct+EJjUwZZN7XI8ntcjrlSxzBD8RiuMlEeYLVXNjxnQ6FskpWyFnMVzVEIaUfsZVAOK3Gd64mC8KTf68MbNdZZnY9rBnr//+Immr6YJR+qt19Dq/B7I+Ke4/RGIlXm2CgxJBgECaXy3ZYIfN2Lo2IJmag/X99tCE8RtFucZAq4ji0aJEguO382SUs1KBDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6bDJm5SZ22naaKNva7dsUB2Oep09W9noTRz5PEsQbsU=;
 b=WKDa+JElTANajOiONPQIobCcYC5rJ0xTUmwvKv1ZtrZsCdZ+wZ9cDkgp8FHKmLGOJwLukrWk5AYXgmjfh6wqVw4vuH9a9RJbnOtdW9TIiFrkQJT/W6NEP3sTGQU9gecvPjEKeaowkFupneI9uv2iYZtp24BPBpY9sY7R3p/8Lxvjvnw2L5e3BB8svoI1HHpoOWqDo4M0buhQBuqPTCN1iwJBu5vvgeWyKl2t+Rz9IdziyixeIbM0815QFnczVHcI7oEsAWDXsaQp4tO4HhQFvo2IrXKZ8PZqfgp/DTxXstmmbMiEWf7p1aVeLCBBgYxW1ACp35nIiP++xWFlaUWQUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6bDJm5SZ22naaKNva7dsUB2Oep09W9noTRz5PEsQbsU=;
 b=tpKqCKhda8udiYT5a73HWIf3ppqOt204Vsq9GjIhU38BwdToBfbRAmTOaBp1Khv+P2299/ZfkcQcr+pTliCXUU2P+B8TYoHnhlu8RvlvxfkJNj/q8zdotdFwwPMAdiUx597OiEnhVbcdKZNZhTX09IeIwEPqkIVFcrgBtnKzM6TAmXOyRn4b3ZOQlDzhMGlCEtztY24G7hWEquyFQ4GMLarh1NJM8+Yc8JLgpbOjNvQYIM/QB9YX+uRpWAbqRMgiQqUi5wjk3IY8DN9kjqpIZ3Up+ixT4runQ2+RofqDheSZmNBuwfFAXcrCm9Hhdw9CtzxlxjSdlpwTZjffTWxhuQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL1PR12MB5256.namprd12.prod.outlook.com (2603:10b6:208:319::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Tue, 25 Jan
 2022 13:11:59 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ad3f:373f:b7d3:19c2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ad3f:373f:b7d3:19c2%7]) with mapi id 15.20.4909.019; Tue, 25 Jan 2022
 13:11:59 +0000
Date:   Tue, 25 Jan 2022 09:11:58 -0400
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
Message-ID: <20220125131158.GJ84788@nvidia.com>
References: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
 <BN9PR11MB5276BD5DB1F51694501849568C5F9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276BD5DB1F51694501849568C5F9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0229.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::24) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95bd92d0-bf4a-4a98-ed7d-08d9e0044510
X-MS-TrafficTypeDiagnostic: BL1PR12MB5256:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB52562CABC94B2BB8C160E8F8C25F9@BL1PR12MB5256.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gQEWTRtSu3phATNqU2F6mifGxwdbE72ylAB9s3mpEQpUn8RWf5EUga44MAgse9ocVpOFi1sERHZLnM/1xA7U1Ss8YwrZUMYU1BBqZhCLXZdHnu85b7QS3mFSr0WlOqfi4SapX7UXBWunOCnUdG6vJc4pAcWaor2CgTLFjH3zv+83a4oJqU3cBVBpzHioOy/v94QFvAO1+k2QWVUWg92WURcPo2ZoAZAWdaC3HVowaGsiVGdiuGcKp+RQrpNPprOcJbnjMmJW/d1CA+5SzjuddURvPJntkJJAFB9hBosywmRjQ4Khg7ziw5HHghX5dsEBn0WUnvOnLd3ZWR4GttAeEQZ0VTjeKXq1TJ8y6/ckcY77oI644kwVHHbVQmBqNGu9/4V42UncUKQIiAP2yC8ZEsNn9HfeP3ToXaDsWGn7p3FYVcxwmt6oUb5UmtUglheoqNAPZL4l6jPkRu10rrENuoLIDGvrO2ULtrdnuY3SKs2vyV81bpbRTlKJGvQp1Ko8fGeXTGKTOpj0kXBGMA2Z1jWuU7RuAsDsBt2O8QOkSPjEsUX7zvlyLTNjeYN+sWSMr2V53FBRRxVaA4XZ6GS9OI9j+gs/T1etw8LbfCHQH9Cmw/YFKKZDoXoyRVvABLJXumuoZ5zcMiYRiYzEou1nlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(66556008)(36756003)(6512007)(66946007)(6916009)(38100700002)(2906002)(83380400001)(8676002)(6486002)(1076003)(8936002)(107886003)(2616005)(4326008)(5660300002)(6506007)(316002)(186003)(54906003)(508600001)(33656002)(86362001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aQezmvv/1YedOZFQBN+EtCjjV3BtO1L2TRW2hCixfCSR/75mhf8UslehF+6v?=
 =?us-ascii?Q?xDQgCJDQ6wBbnnUsJrox2V05e1lVKGFueQx+SA+OJY/dxqQA0kjuHNExHNvt?=
 =?us-ascii?Q?dVqiYBfBi4vwBbndRazKd4is/XJD0yrVRtBsIlZlrkVgHOCHJbHWy5la+NvU?=
 =?us-ascii?Q?XjB573o6KfIr4UTWh/8PpSnBHlJyLre5P1twfeE93+2pfceX+ajih0CSELY6?=
 =?us-ascii?Q?r7nNu6hSUodX0UtF9nKPYWRX2KX7jbf7m7c7Co4U7iMUhSznO4TEyGM3i0xS?=
 =?us-ascii?Q?19hF9d3oZaett+j3z/JcnfFMUHajjgO6NbUePXx8rlV5B0HvbKZHuqLVRrgn?=
 =?us-ascii?Q?6hYOS1gx2ATt8on1sHdOOEBUsLNPE8f2bf9HS0Toch3WeSWPAvk03bLF1CP3?=
 =?us-ascii?Q?NNDlOlqQQUyMovtgutc4CxVg3mcnMZhZqXqrfVS/0++y2x4zQGm98rmQY/nC?=
 =?us-ascii?Q?z++cn5/ulYSueTJfjFvMRVufI1ovwGo4eGHBXQLP/7Bw+C9PF5tOFg0SjTI6?=
 =?us-ascii?Q?kdK7kfeFkUoydVJ+SM5a5smXyQznvIpRrgFySbp2+2uj/KzAac43rm2T2Sel?=
 =?us-ascii?Q?VsWJqaHvWLWlqT6z8nl3JAXwU/+0ey2/QG1Dckj3GxvGLeURwDSt+HRUHQla?=
 =?us-ascii?Q?nfLe2Nq6Ce/A9QYUpGQpMVAUHnfNGMAX2cmKNAbwZC2TblYc2o0gnvm1rlzn?=
 =?us-ascii?Q?PJy2OyXeAVP7Cr/ve6wE8o46t5JUxcKhbxmNGK/ErIs5nMPQTdLmZzbaEZ8e?=
 =?us-ascii?Q?IeMeiJ902FQtndNey1ZQUl4xc9Gyplo5EwL7BQ11wXc/IYY5CEQwixzqydG0?=
 =?us-ascii?Q?v0ipqoY6gS5iWdUf6fKyqeNd+hcVn0qd4v1AGsk6wl4dm416tAuERocsBJaA?=
 =?us-ascii?Q?ofdKEH+v2kOnZ8OQ5tIKVFfS3A8UaaGICAPN3adFJNvHiOUY8KmMSpmWzwSF?=
 =?us-ascii?Q?xgo9VSau+qUUzKyircuGK83+guEEr5YvatX/prNJrVW1pC5NaHYOkooJOV4D?=
 =?us-ascii?Q?91P9O1c2UCeXKJh/oq2BHmaqWdmQHiWviFKBvhzTKZzoeiLwmZIfcZ2tYkNA?=
 =?us-ascii?Q?+XbngJJ6ZvkBqM05O10rgLFloaZMYHoXMROerIgD8YWeNGEM9CvILi05G9Bz?=
 =?us-ascii?Q?pIn9mgb/dJZ7OcXYV81+Fx1bz1U+vpOqCOMhyI6105AtkXcF9W7Thpbd/KTa?=
 =?us-ascii?Q?eua6NPfHiOEHLDBxHRzMPjTscLRAOznXFwYT40T3HSQJgbWpANYSOoEQrY2x?=
 =?us-ascii?Q?dVOzlcBvZqktirZyhvIiefzI8QPZB29zqJPG2ETeFO2BjjnrJerWrCuIA5cl?=
 =?us-ascii?Q?Ha6j6uW3IsIWbkRfcsVuuaNKMCVVjICJ/Q6l46QU/3zfrqAOILM7A9crpWmb?=
 =?us-ascii?Q?M78D5a33KdOQZy0PqdEr1fhrkc8ZhCkWBGPly8MiOy+sFuBIoUJgRzmMSG0X?=
 =?us-ascii?Q?MD9A81zXLpcjr5CyH4mA1pdYWBXAYUpZ8CSvAAHKuP0g0uKKtuXMke3xkAVQ?=
 =?us-ascii?Q?+zeC26UhTzi2uAVkU4DJ2Ez5LRH9BEhmXP6JvGO1w7eP4grt+o85cnrLvSkM?=
 =?us-ascii?Q?ACezZNcg3eTg9jMjz+Q=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95bd92d0-bf4a-4a98-ed7d-08d9e0044510
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 13:11:59.4113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Jp8PvCjRWb2a4hC4hznZ1eRsEXV5TItcgMb/7ynaUEl0xHhNbQ619r37ToZi6nl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 25, 2022 at 03:55:31AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Saturday, January 15, 2022 3:35 AM
> > + *
> > + *   The peer to peer (P2P) quiescent state is intended to be a quiescent
> > + *   state for the device for the purposes of managing multiple devices
> > within
> > + *   a user context where peer-to-peer DMA between devices may be active.
> > The
> > + *   PRE_COPY_P2P and RUNNING_P2P states must prevent the device from
> > + *   initiating any new P2P DMA transactions. If the device can identify P2P
> > + *   transactions then it can stop only P2P DMA, otherwise it must stop all
> > + *   DMA.  The migration driver must complete any such outstanding
> > operations
> > + *   prior to completing the FSM arc into either P2P state.
> > + *
> 
> Now NDMA is renamed to P2P... but we did discuss the potential
> usage of using this state on devices which cannot stop DMA quickly 
> thus needs to drain pending page requests which further requires 
> running vCPUs if the fault is on guest I/O page table.

I think this needs to be fleshed out more before we can add it,
ideally along with a driver and some qemu implementation

It looks like the qemu part for this will not be so easy..

Jason
