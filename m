Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D4D3A6BE3
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 18:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234703AbhFNQfp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 12:35:45 -0400
Received: from mail-mw2nam12on2040.outbound.protection.outlook.com ([40.107.244.40]:34401
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234519AbhFNQfn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 12:35:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XTsZkOfGJkl8ae9mHkc5BINQsnrYLqMBagKziIoXu3SsQ/qibVCSnmG3h/nO8JSZCulWIXbLT5vJQJ7lWlTxUwRXRtDej2eSCyrDktZjgjRYAVvYDwJ+ld0ZBXpd+/te+IaxV4CWSLQlZjl/IOqTjCGambf3NS+TzjnvcHmGn/KshThDgO6BGn+lwQAhwiIGMNDngExd1LT1MZczWhAFxe9SoZmgoEytqdKsRXSQIo1taDQTxuOchLO/2b44KPkh+bkWJFKSWVlA67oKACeunD/mLqoHBfiuzj7hJlOwJQhoXZsYt3PcjIxOK44edSvALWkUJCgKadmAoAfWblTQfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aL/4GQh1flRbdjumQGf3Fp/2+iBChN3lH4nOd3SA95g=;
 b=gGeqWpnL613jA+yIHRPKlhORu2ablXQaI+8rKHM28312xHwTl+4I8/qw/RNrNWLFN6GHkBr3dl+nCpj9ApfgNqS9zfyoJqpaa+vgZ/1n4wEnFPS5MEIPaFseY/87+8Fdx+vSI/2dctM1CZBzTlhf8xswLtVoesknaEkgGpTV//wSaSVrOMLuYjQQpFC4bFZ6sn/LaUTuWI1Nu4YwLiuaiQvEvuvgdFsJcxS19V967tepf1iJTZKoN2HhYoug/c3IQpeno7h1mrKsCs4oRd8xfIKd44ONeIetIpDvO1y9Whz/FFL9T0DjC+vPx+DiboeIg/KOr1zVeyiBDCH/slKBcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aL/4GQh1flRbdjumQGf3Fp/2+iBChN3lH4nOd3SA95g=;
 b=EjYv8lPv+haLoZMO38sCc874SPTIq9YOm+QSsaygI/oc2X+nfM9Aj68Jru7lXhZrc5H2o4bRz4unGP1lC4nKRCMLrDRYmNwFfh9el5zzG22spLDkRZznEZiJc7vKngww4AMB89U52RggWkMvftPKhRYaaODgjNr93EHd/BPyZ2fTHNHQegl5Wr46IGuPxzM0DoC2jLUlukn7D4jdpPBX+ZlcjmjWUlWGgS0+mhG21PIT2t9Jnk2L90TMQ+zNv7Nz4vOF+l43ovSD5StDGSHPAgPRYOTVrG1Xmdjepd0rpPcbsZWO/ya3RwbxO25usVy8SVBotvO0YIyE4WmTB0r9Nw==
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5096.namprd12.prod.outlook.com (2603:10b6:208:316::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Mon, 14 Jun
 2021 16:33:39 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4219.025; Mon, 14 Jun 2021
 16:33:39 +0000
Date:   Mon, 14 Jun 2021 13:33:37 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, aviadye@nvidia.com, oren@nvidia.com,
        shahafs@nvidia.com, parav@nvidia.com, artemp@nvidia.com,
        kwankhede@nvidia.com, ACurrid@nvidia.com, cjia@nvidia.com,
        yishaih@nvidia.com, kevin.tian@intel.com, targupta@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, liulongfang@huawei.com,
        yan.y.zhao@intel.com
Subject: Re: [PATCH 09/11] PCI: add matching checks for driver_override
 binding
Message-ID: <20210614163337.GL1002214@nvidia.com>
References: <20210603160809.15845-10-mgurtovoy@nvidia.com>
 <20210608152643.2d3400c1.alex.williamson@redhat.com>
 <20210608224517.GQ1002214@nvidia.com>
 <20210608192711.4956cda2.alex.williamson@redhat.com>
 <117a5e68-d16e-c146-6d37-fcbfe49cb4f8@nvidia.com>
 <YMbrxP/5D4vVLE0j@infradead.org>
 <1f7ad5bc-5297-6ddd-9539-a2439f3314fa@nvidia.com>
 <YMd1ZSCZLjaE4TFb@infradead.org>
 <20210614160125.GK1002214@nvidia.com>
 <YMeAmoWns9SUkr+q@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMeAmoWns9SUkr+q@infradead.org>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR20CA0066.namprd20.prod.outlook.com
 (2603:10b6:208:235::35) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR20CA0066.namprd20.prod.outlook.com (2603:10b6:208:235::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Mon, 14 Jun 2021 16:33:38 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lspWr-006q3e-K1; Mon, 14 Jun 2021 13:33:37 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2985bca-5c1a-43d7-9e6c-08d92f5229f3
X-MS-TrafficTypeDiagnostic: BL1PR12MB5096:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5096E5C865AB86F059FB5F1DC2319@BL1PR12MB5096.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vNhJtrHtcGwWlRRsvRfOlOHAKEU24fRSscx2CInsdxokTO32vqcEtuI1a2gw6BiAA/75hhDj7MAf4l+qT5FmV1xpYrYSwKfo4bWlLI1SvBMYfi4GPY7LiEUED1d+Avbn4xqXxHW5wM+PTuc/XCm/wfDYSu2B0WltQ32vN+CizB76Qvctu8bABOyw9sg23ldaihLkiD5rkIPoLGWT3gvFZJKsjhnnLEbjjjks82zzgRDNa5vcDXHrhWJxGTzHdNImpkg4+6oWFbmP7TOa2cnJ63S995wIhPlPfVk+ImYRgWUjPldqM4B7hE1UjjWG/eSbKrVcy5IIw06uql5BuvE1/CtKyQdOr/M3dZMFSceIPvR+2JXFOCSjaDCCFMFy90sq5nrTJInoVlH+RcCY6UWRaqrFsEb3iZbVN6muFzL3d7wPGlirrd/rExKaW0pVNYqmttGa2S9hirYzf5lKBR+k0K3aYDHTqEfXYBecvurl/xZAQBrZWD+hJLo9yx55+0SvU93r1T9EmfRI60iDTSPgy3t2NE7fox185D5ifz32akABQU3lTTRNKLYDjiC5HvXiyKX9pE9c9sNM0r1iG7CDosUfm4vXK6vkL0IKDPAkMHs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(136003)(376002)(396003)(8936002)(6916009)(2906002)(1076003)(2616005)(4326008)(426003)(9746002)(9786002)(66946007)(33656002)(66556008)(66476007)(86362001)(54906003)(8676002)(26005)(36756003)(186003)(478600001)(4744005)(38100700002)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6bRCJ7ZGVkTz4/AdXS4idiawi6k6oIj02SXw1meZkHwTkIpqQxnL/AKmEgpw?=
 =?us-ascii?Q?1WSYXl8GJQRyVJsWbXauIy+jp9NtBidwd3bKmjiZbOk+GQk1ezbbhMAT6aiS?=
 =?us-ascii?Q?qJ06TdTUqVJKoav+jZUFHTyQ/Z0018zqpcu7o1G79SswWiXEhv4fbYtSCPDF?=
 =?us-ascii?Q?KsiZwXsCkFBgPVuLN8NIKXx/QgOTWhf1u/F2kC0WvChZiWOR3nAAPSV98UgW?=
 =?us-ascii?Q?r53GsmBten0Qeu8Sz8bF+DSWIPOC86XLJIwhELqnHlZ5GfgiFf98DunMKsb3?=
 =?us-ascii?Q?R5guuaq6evI9d/OII7CSzDPCbKl8nBmpGwzM0hHviGLiA3sNBfcnH+Vas9GP?=
 =?us-ascii?Q?BevADFFWumZHoVyMCByVOtnAWtZSrbth8lmlmIs3dWER6TT8FMQt5f3zqtMJ?=
 =?us-ascii?Q?2CLjx33KgUyGFo+SZ8nnZo5kkaE4jKMjSgdpeFwcq15wOop3izQjNae+hVYg?=
 =?us-ascii?Q?jg8QfKdcdGWWGEx91zKr5Zhx8lK1yNvnl5tY5V7f3Ic09ifCIZb4Jeee/zjU?=
 =?us-ascii?Q?s6QGcmvsok121ouTrImvO0EQPLcDeARVpdTE2jV77NEWkCWtBbeP72rC/+BU?=
 =?us-ascii?Q?YcZiNpvjJW4UJGlqBm4IM6Aw7WiTWjORpgwpVDcIZAk5ZNkZ5hJakdwWXc3C?=
 =?us-ascii?Q?cTfMt2tBPEKvOAj4Im21/sptPvRLa1qCo81tQ1Lx4FhWW80ojA9IEzarsTTZ?=
 =?us-ascii?Q?+jiO96FgF6zLaHMLrNZOhks4xif5gw0ODD50aQFFdO1G5wwA9cv5CTabQ2e5?=
 =?us-ascii?Q?5esMhzyBvUXdroynwusxHO3H9bBKOmnF0qfTYkkVaxQxR8MUBYQYp0Toqwup?=
 =?us-ascii?Q?zZtlDfIKzACPy6X7nesUxtXJIDlCkmydd0ybzy8hTMe72WBw7MmpppDIhSEF?=
 =?us-ascii?Q?C5HuyueIKF+Zdzh7xguxKfXRLqin2dgVp6ok+Npc/cKK0anTnDPChyFEweeT?=
 =?us-ascii?Q?5+vpwpm1EeLfPNUHdDD2kwed8OEQi19JMQyfp7KzYer8fZKKELiKPFE1sCq5?=
 =?us-ascii?Q?IsmMhX4O7lH4sGI0rbBIWwKtsjLRCrTx9SXUHAFEFB+0mdtwUq86d5JccsLa?=
 =?us-ascii?Q?C0l4X5ASHyCtu1mIwVidnj6GQb1BeDAnbqQHn/ukQRboCxkCRiYPddrjhCje?=
 =?us-ascii?Q?cH06JbuH4C/aZnx+YzpSoiLAQYxznXnDDRN88i8DP2X1VZeXEoaYoJ/7S7QR?=
 =?us-ascii?Q?TslHjibesCYSpWfHpx4Yd/uL45qOQILEdcSWYgoJCIuaY2bT+ittXefYkNUS?=
 =?us-ascii?Q?e0GAExQv7yTCmop7/2JFhglKEHLt8X4ycsCSInWEL4r9F3KL+96VtdV8WLBq?=
 =?us-ascii?Q?5PNxi5WBdYoYrSqOmW3h3zIB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2985bca-5c1a-43d7-9e6c-08d92f5229f3
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 16:33:38.9929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O0mERGLEYLTrQVjqDjqZNSgpmLh+gFlyc1xST/0vR+rD03kctOEAaS9nMu4ErfO4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 14, 2021 at 05:15:22PM +0100, Christoph Hellwig wrote:
> On Mon, Jun 14, 2021 at 01:01:25PM -0300, Jason Gunthorpe wrote:
> > > Isn't struct pci_device_id a userspace ABI due to MODULE_DEVICE_TABLE()?
> > 
> > Not that I can find, it isn't under include/uapi and the way to find
> > this information is by looking for symbols starting with "__mod_"
> > 
> > Debian Code Search says the only place with '"__mod_"' is in
> > file2alias.c at least
> > 
> > Do you know of something? If yes this file should be moved
> 
> Seems lke file2alias.c is indeed the only consumer.  So it is a
> userspace ABI, but ony to a file included in the kernel tree.

As I understand it, things are tighter than that, it is only an API
between different parts of kbuild - so it is OK to change
it. module.alias is the uAPI this data gets marshaled into.

Jason
