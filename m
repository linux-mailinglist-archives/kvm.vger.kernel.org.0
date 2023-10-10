Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5C97BFEC9
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 16:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbjJJOJA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 10:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233028AbjJJOI6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 10:08:58 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860E6DA
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 07:08:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PLO8p30fTNXkrPodwwVn1FT7nh1YIsaGKd0l9ZayXkbI4GTsXDFif0pO3hIQCZNNON3Qv9CwRKeY6v7fXygrOoDaio/F3i7xg9rzktzT/gUcgo2BjrbClJI2h9ZNABeoIOp8JzYt/soj4fKxJKqCZCyEdWqnU8yItUWPVaFNtzVR40YgNepknI+Zik2UsB2e5TlbqopuaNx7RKH2j8563+EAAkZg+LK3ItjXPuN0mxE3WnFZhXMvQPIgSkrO8/E6yZBTiwSCy08R3SzJL+AW4OnzhbM9Pl15nL2tE9pTl8Wx6wzdVSpSoZrwxGGdsQ5jvjgmRXrXmkTn1YjjLgr/cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XhkYkNPdlBVhapplpfaJ4tBd62h2vQPKxQJFgssbjlY=;
 b=nKuRinfl17bJjovvmdpPouvphNqK+Qc2d9HoV5ms8XXwwPHRRU1YftkrhhjSJkvpyA3iHId+E9tkHWOuYQFLrxVKdCHbYVBZtzPCkv0wuKctybaxPNLc05OezREjypWp8/ZuR2/L7u3P6DTQ/mwfk2roK3Xt1I9fkga3qSmdl6qbc8vKe8q7f+RLHMq/MOFOjNyrJK0R/37VjYFNuGMdlclL+JBfrx8PVUi7ATTPNBAy7BbzwpfPBCD4YWpjRIrKA7AGqOyZEd4LD7DZbvwqCLqXHv07sMJc4TTdslc9VpVhAM5QrVYwKv1I8/BsJt93UwpA1jlGR56XQXvcYu6gDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XhkYkNPdlBVhapplpfaJ4tBd62h2vQPKxQJFgssbjlY=;
 b=qkEMxxHJVWAXLgBI6eEqqfUO/xGc6IzlDicXV0xWhIyETF7QXY2cIRFq9U18n7TNQnvnGW1Z5oB5I6gGXTBf9OL8Irq9R6r6zYKEXc1sRjGocOanZC39hysX7SNBGhYvJjlMHz30NPIHl3OjFCn6rMhHqaFyjjsKHslh1jUG6ZQSemG8+1Si9GcJTHNlqfFO+dCIu3FgSBKKsyM4obIgxGpjyOT8v+zcDHltG9NK2D+kUPetrTxYIocElDT8cKk2PFpA7B+lpSxmCUD+JSgc6gEm8DwKicrt0LJyQZYuBI2G+BC20dTLLHg+o9lS0PScNhdnMIZlyV5HDgFCnS5QAQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BY5PR12MB4886.namprd12.prod.outlook.com (2603:10b6:a03:1c5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Tue, 10 Oct
 2023 14:08:53 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6863.032; Tue, 10 Oct 2023
 14:08:52 +0000
Date:   Tue, 10 Oct 2023 11:08:49 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20231010140849.GL3952@nvidia.com>
References: <20230922055336-mutt-send-email-mst@kernel.org>
 <c3724e2f-7938-abf7-6aea-02bfb3881151@nvidia.com>
 <20230926072538-mutt-send-email-mst@kernel.org>
 <ZRpjClKM5mwY2NI0@infradead.org>
 <20231002151320.GA650762@nvidia.com>
 <ZR54shUxqgfIjg/p@infradead.org>
 <20231005111004.GK682044@nvidia.com>
 <ZSAG9cedvh+B0c0E@infradead.org>
 <20231010131031.GJ3952@nvidia.com>
 <20231010094756-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231010094756-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: MN2PR19CA0025.namprd19.prod.outlook.com
 (2603:10b6:208:178::38) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BY5PR12MB4886:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f86469a-218b-45a0-9ca4-08dbc99a6eb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YjfI8WNHp3r5BzEr+6oH9oGxtfHA5/EYDFO6PcAKBBfX4WnIKJ8JaWn9agwhDj1jLwAweVn4NxtCh3hVMg64twg9qWO1T19aeGB47TvWCG/Q9VfoXelG9D3SCyOxAdjrOvMLQJrXLF1PS7JUUGWmuZ0/+ym+1ZpZspRhLlU6FBgvMdu9AFQHkitbDQToZWVjW/YvLvIjx4DSJF2fO8u5Js3a37vrKlB132flmKbqnZlSn3P3ajA9Wr0zTEk74Q9NEjAR+z1q6WTDWbSrIG4E/ziDWleMRzTJQOCWroTi52VbLIPXBnBJyREPJJbpRd1d58ZkGexCtRvehtVIaaeKhhWiI6NXcT2u3G3u0EIiQ/jzbx+agm+hnYOglE8kwpM6KhL2NKozZZUGBrNYhU4uFOCk56ffWTSuxG0+cOXND4v4X+b7vLb1ES2i7l+1o6TTwIr9wZL4Z24FhykIB8Umqkk5UBfYKly++Cnl0TEgWEHPQKo6oiU+coI5dcU/mw2G+soLF3rnuP6YejGoqumFyQvx0UV7nemFOgSGucfcBYGXsKFz9SiSVvip3prRO2f/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(396003)(136003)(366004)(376002)(230922051799003)(1800799009)(64100799003)(186009)(451199024)(316002)(1076003)(4744005)(54906003)(26005)(38100700002)(8676002)(4326008)(83380400001)(8936002)(6916009)(6666004)(41300700001)(66556008)(66476007)(107886003)(66946007)(5660300002)(6486002)(2906002)(6512007)(6506007)(478600001)(2616005)(33656002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eOf9ZZmwiTdBbVd2KLTDHzOnx0XCxpiCwxyG41VOznLsCgcn39//ovvRamcQ?=
 =?us-ascii?Q?UyRTza6ZCtbu3cOI6ETuPX/NhcVI9VDUkhZRSJSdMb297UQh+CoZi26BNm1O?=
 =?us-ascii?Q?/GTiItKRZLHkBoH8hyI3GmZXtqgczqoW0oeRt3OrdZVeqIoI3+TO8lQ1cxKl?=
 =?us-ascii?Q?+EffYU6o0DwEdDNhmdhqyyCzzKdTVaxet9+QIbPPAa10JfBF6Fg7E7umf+k3?=
 =?us-ascii?Q?vJx65r6t4M+d1ynfaWHpRvnjPVmzhUUT4SULdt4wRGn09n6CBVPn6/7zdC51?=
 =?us-ascii?Q?3i2atUHxRD6RVX0xBhS4SCAPHy/FmtlPwaZ/ePG7yv6RMU47TlPNEKG2bNTM?=
 =?us-ascii?Q?k30B4RtvA3a/Ro6tzaEs62QLbtJu+qRTrWibn0AUQhgN/yQeSNs5V33N4ePg?=
 =?us-ascii?Q?k1plsxZXc7PHEWt6J6IomQiziZFKwJsP/FlUhiewKB+rTDplhpeyRBrgxc2O?=
 =?us-ascii?Q?SaxJD8G4KfhNIHtqlLiEncuAsLx1ZDnVF90lBRehkhKzOreqNQPPT89QxCGD?=
 =?us-ascii?Q?cEYXAXJcr47um095wVdxzKrmiED+sfNipViLsLBHwclgv3cT4zCdF5Nvb+Vt?=
 =?us-ascii?Q?+N/q3N05XyM+Xqm7OJJunV8V9Qh1BlXo618WViC6rgqs7/eaqn3MJtHwp+xW?=
 =?us-ascii?Q?RaqSlIDcgyLckK1/YlwRW/OsAMBQ+Dus1FlzBITu7le4cc6teKjqciCZM/sM?=
 =?us-ascii?Q?67A+ZYwJpD3WUWhd+Av0RuHfHIUwHFPz3yHPBslJscqS4KaFevkXwsu8P4pL?=
 =?us-ascii?Q?yF0533pWoVLWI1P/1vc8mAb2nPYlo19CuNBbnEJmGhX1SjCA8cFPxH5pTcEQ?=
 =?us-ascii?Q?/BKwtZvM3OniboIq6lNbT1zwPhNOr24eZwWmIFZjD99644HVNIGW4ouS4EAK?=
 =?us-ascii?Q?Ifkw12A/ncVrF/IsFoTHZbW7iMN6fVmXFqJkJV7NoX0lEWUEBLaleOBDiQOf?=
 =?us-ascii?Q?hwgN1EYxFB/hdPyY8s8+80jQgauo8iK03n2gUMQjysE1kgVMkvUHRngZ+mAK?=
 =?us-ascii?Q?KjY9xm1Ah/8Bq8wXKyBC7WEopjwNomsfWyhrY8JKEl2HrkzMdbTdhUcmN3WI?=
 =?us-ascii?Q?kyLXCQMc0acgayR/i7zNOreO5dCTMLItTjkFSqsSPPW0831x5nr0fJzsy4Ll?=
 =?us-ascii?Q?pjeaJ4b44FZO92xoX2egYCtZaR6PYocdaAjThtNjLCJKOYj2mSq4VMuxo5y6?=
 =?us-ascii?Q?58zcXQiip9+P7A0I78ax+LZbzj7rD/Av/wLr+KTmsQNiPsWIKJG2gd/Q9SeW?=
 =?us-ascii?Q?FuGycLpFW8L9Xjq+JKSWOkgoL83zsvhcQYyZ/vQKqD8yu3pfhwMgXZGDkZ4X?=
 =?us-ascii?Q?N6R1fHysqjGHF9zrGOyAahDNRPmLtV0CG2uj7T4u8pMayh6E5/6m5F3Y8r42?=
 =?us-ascii?Q?qen4SLuOrtCVWJ4HK57aN7vN8S9XyCL7ibo/87OO6QQsDn0dxx2LvEtMQ28i?=
 =?us-ascii?Q?D+BRttUzT2IJg6xsRNqtqgN1voIDRHXJwAkWTm+QhivO+u6sB+Wu4e9VCjvX?=
 =?us-ascii?Q?WPwOAH5/eclPvy4rhNPtXeE22vhsEqIuoisQjdHD8LTY0s3R1C3/ryE2ZmP+?=
 =?us-ascii?Q?M28NbRVqH0uGZw46umfAoepc5sfEW0ID17PQnowq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f86469a-218b-45a0-9ca4-08dbc99a6eb7
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2023 14:08:52.9263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ej8hi0fXexkLM+tIhpQ2LI+d6qlfjX/JdA6SNNr7hu6XlYZQuWpnTDCSiuJ+VeDs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4886
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023 at 09:56:00AM -0400, Michael S. Tsirkin wrote:

> > However - the Intel GPU VFIO driver is such a bad experiance I don't
> > want to encourage people to make VFIO drivers, or code that is only
> > used by VFIO drivers, that are not under drivers/vfio review.
> 
> So if Alex feels it makes sense to add some virtio functionality
> to vfio and is happy to maintain or let you maintain the UAPI
> then why would I say no? But we never expected devices to have
> two drivers like this does, so just exposing device pointer
> and saying "use regular virtio APIs for the rest" does not
> cut it, the new APIs have to make sense
> so virtio drivers can develop normally without fear of stepping
> on the toes of this admin driver.

Please work with Yishai to get something that make sense to you. He
can post a v2 with the accumulated comments addressed so far and then
go over what the API between the drivers is.

Thanks,
Jason
