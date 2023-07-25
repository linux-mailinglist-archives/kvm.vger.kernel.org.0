Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2141761685
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 13:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234919AbjGYLj4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 07:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234881AbjGYLjz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 07:39:55 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2074.outbound.protection.outlook.com [40.107.244.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13E811B;
        Tue, 25 Jul 2023 04:39:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YHCgUMnwpKaopgL+JwQr/5EvbyV2Urq4aL6ebjzy44BQVvnCgEfn1kcUyK7RFdb3v371QAJ419pNzEJtkvCFREwNgDear3725EPtjRc+rhojl9QWLXpxRfFDhJ1VgcLnPtQ9R3Fvvbr5+S7ZQhdkiVpUnf+TZJDnstgUS6F8uMiLBsjwFGCkWniwCHuyN64wOTqLEyCXjQUJZtBgJWVlXaB6AZQZyJbc1OW9J85fJXCqdwc65nSRkVW5ssN+B0odya4+ISzISdp6ccUOqx3AgSqFBtLYKld/UjBcM7OenTD34Uc2igI9pKn3M9XQwVed2/oSJIc5o48xset6LefoXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Rq3oo6dG5NtyjCqzeaOhQmL6y9md63CI+T7ceOBsFk=;
 b=I19+g6YuzMcyjzLvqXM8uyckmq/qq3xJOjkjJrT2rPOEA8ZsHnHREHGyEFd31LYX8SigpXr82jIpW/lQf7ynZlxlAHLl5F1u720zMvmHr37tGkK08RI7AS9Y3xi2DFb3Qiout65xqeUdY4wh81gpzH2Q1HVl5/g4ttBCIWCVKB2NnUlx+oT8WkJbTfT62mDbtpN5ry93AyvTv/pNzRqy7tpdfWDj+Qa8aVkbqUJF+q21Rbfy8HFgOIQc13hCppRQav9cp52GmOM9kuk9QrAzjFW5WB+Jnd7eCfqX1zQmIid4VoBtIRzKCbxAjqq/K++DFbHu/CMkFPjrqDgjQfHNJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Rq3oo6dG5NtyjCqzeaOhQmL6y9md63CI+T7ceOBsFk=;
 b=HWFUg6qd3/YB6CqUlJAdDdrku2vZozLsFnCuB919yRG7EmZtbQ1DbzJhK6HcjenfMJSb3v9exxHr7DW9gkbS4tHDQHvQUrm2CY+n8/5aJnTTqkiVtjdnvnxt/a7KwEtAxNUaKfBQ2lRcKnst/ZbHTaRrht1L/aLPxkUUXWaQZqCI8oS70chiM+3gBECzLx4XF8m/dP4wFwiTHijb5AdN6MXKRalEWvqHuSjUZ1S6un0U1K0PuHHQO+g7ZOJD9cdoLjhayK1mhlZ4YHjeBtqRtaHDHMgVJDUL0wjbgBLCeVBlBO5Aud5WFEhECCN+HqhC2XRnizqG5tnokC35/R084w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH0PR12MB8030.namprd12.prod.outlook.com (2603:10b6:510:28d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Tue, 25 Jul
 2023 11:39:52 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6609.032; Tue, 25 Jul 2023
 11:39:52 +0000
Date:   Tue, 25 Jul 2023 08:39:51 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc:     Lorenzo Pieralisi <lpieralisi@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
        osamaabb@amazon.com, linux-pci@vger.kernel.org,
        Clint Sbisa <csbisa@amazon.com>, catalin.marinas@arm.com,
        maz@kernel.org
Subject: Re: VFIO (PCI) and write combine mapping of BARs
Message-ID: <ZL+0h9gvJGTyWKZX@nvidia.com>
References: <2838d716b08c78ed24fdd3fe392e21222ee70067.camel@kernel.crashing.org>
 <ZLD1l1274hQQ54RT@lpieralisi>
 <ZLFBnACjoTbDmKuU@nvidia.com>
 <bc6c3a08e3d0a343fe8317218106609ba159dfe2.camel@kernel.crashing.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc6c3a08e3d0a343fe8317218106609ba159dfe2.camel@kernel.crashing.org>
X-ClientProxiedBy: BLAPR03CA0066.namprd03.prod.outlook.com
 (2603:10b6:208:329::11) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH0PR12MB8030:EE_
X-MS-Office365-Filtering-Correlation-Id: ca050d60-a27d-475e-9ac9-08db8d03dc46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g4kfOMAUNjHmP+1uJAphXxSAXubL+Wc9hsFKWUwomfYWsokmoM/eRpshwVkalGW9zIuUzG63IpEcjgvnvcsVp6/6sczMuC1i46Dsxxazw4RWXz2cg9TdMC7Ea9Zwi3Q1s8RLtzWgF92X8Hx0jqOw6NHBgkPwjmQUWBHnayKq8xsjg6atqphRaxWbbxDQprma5afM9LdnNFennnZNhf06obWgBSdpWfEr3XcM9ISuny+rtLIy07u/TTSBTLpi90P5WDylXjSy7XVmyqwgkLMJTyn1LzywGnUmQF5yDoIwd0OF4W2Aui/E7IH/lnAaYS91JwwT2I0dHDj+vw2yB/vzz7dgjmutuZoUApAlCrVpVgKIONDG9x2KeRc8niaIpymUeAIgdfGihf14Ni36D9yQrUhSFHFS5FW9CgvG1oyqD9Uc/5vC4im/4zd3N2smqIUjXi8YP68cAMywuSVhalet+LJ/AD4TzXfwGQBRZXD36XbcGR5zrsC6F/jUj0qO+Ddsl6IalczUYzJ2GQdZRErAuJZ6pvMURMoNLq3/hy7q+O989MkzKjY/5pqghUPs3+p4Sa4DWIER+rCBwl735RsHzLejszyIvvTaBR8p0Au1xBY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(376002)(396003)(136003)(366004)(451199021)(26005)(186003)(6506007)(5660300002)(36756003)(8676002)(8936002)(7416002)(2906002)(2616005)(86362001)(38100700002)(6916009)(4326008)(316002)(66946007)(66556008)(66476007)(478600001)(6512007)(6486002)(41300700001)(54906003)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CBcXgRrjIDB4Gppv7rz0tF0WJyBS5v6v2Mair4S3RsUC6wqspUi03n5Czu/R?=
 =?us-ascii?Q?Lk877nlq9WI1h4m951yA7B+JVSoRDSHXopnSvoYLNwNOpMLtfuXgMIB+4D8O?=
 =?us-ascii?Q?rY+P8v4mJ93Hrm4S3UsxZaw3PrxoT3WebqRSWIU1wjhtlTMngS60CyDXtoiF?=
 =?us-ascii?Q?1+JiBx+lIU/z0J0kH9PCL+DgYuAt/lhyPd2llgcxlNs66QoMO6ikVfsVqbxI?=
 =?us-ascii?Q?MgSm/vFzOHWSzDtJyolc/jxQFHbwkker+lkoMTH7kNMx7ni9wqPhBKffRT5w?=
 =?us-ascii?Q?CfSS67sfMpAQJqFraDFgE7y0Se+4qEeXcD6/fFXG6xzFCXhAI8rfXnqhE/Tt?=
 =?us-ascii?Q?j2mw/G9LOQe1St6TNFSKIL8pp4T97LK6bDAI3wUTh7Go9npB4sHQJuvD7ywM?=
 =?us-ascii?Q?D1tLSBaj7sbHs0NU55PAd0vowaKLj7Ynu5OwAWRvy99XoZZF+h3v/QmSaJWV?=
 =?us-ascii?Q?Rn/HoBkpy/Nht9fynuj341+IA/afflA1XVrwaJCUDlWOfPGnioO/yoszofgJ?=
 =?us-ascii?Q?iAzbp40Ne/X4tFg5o+LKReVjyN8ayTlUl+bLO9qUeX6EDskn0RE0VGypgLbr?=
 =?us-ascii?Q?119zQNeLTmPWwRnTOXTG5E5Gx940YZTR1vvfd3YqFJ0ZW+X9DVBrUH8+f2Jo?=
 =?us-ascii?Q?NcWwx1f849lZheqMyM/7+c6WT39809yKEd0CsRGn8BaVnY6lp2hnOYhyiUiU?=
 =?us-ascii?Q?MaVwd3l65rOFw7rHTtuq/5aYtGPw8hbjAZNS7hnFDBNqw8EDt5DG84nnJF42?=
 =?us-ascii?Q?xGX8PQcZ7vCt8mMSZPIDUKUFxZ5MhVHnVLHHIrfFwMafwlXn15Q/1fNYXUwD?=
 =?us-ascii?Q?IbvtOK08XpXpMHTVM2Cq6/gtN0buoUD/Zcw1zVTG4cvnOtWES55/cvVQ5UyC?=
 =?us-ascii?Q?7Ok1I5mLU5h8XejIbTLhG0AXvQnPNUU2n2BUhoyMPq6+9PR1rvQoYU+Tf2tV?=
 =?us-ascii?Q?w9BgAcPSZNfAIPngFpyuuL7EJhF/UXSuZxY00mNpqGl3B94JbTeNER1QpoSL?=
 =?us-ascii?Q?E9a2rBvev6Su4x5w6L0a2GEp47/0lH0Eupj1/v3wEaX2MV5QUjZEzpOiXosw?=
 =?us-ascii?Q?hzgxCz4hZSoK/DqGB/RSIW+DgiVqT+9Tn/8az4BIPUG5axFwjThE6SNdOGKq?=
 =?us-ascii?Q?x4ceK3bSgOdxYJ18XNC8vApgD5eZB+NbZpEORdqhlCxLdq6YNzYtCTOCA78O?=
 =?us-ascii?Q?C5GCsq9dGsA3Pu0Fxd+xbHBix1cAZaeiUkLPFrJAbwTCsfOM7GG+uAL7H7Ec?=
 =?us-ascii?Q?/W3yQabg1JtaaylV6CB/8p24K91YlFHxYJcFnuSmR12kBh03/EfEdM9rVEB4?=
 =?us-ascii?Q?ZL4q+ZA14fQGWfWBoGRm9X2N4XERCmiskI09qlL6b/RzQyBHEKhPRuhw+hXv?=
 =?us-ascii?Q?faOxLu1h7h90TpP1KmbSSb3us1pfBFgCqSlGupBe99yF5qU5p1FGRffvkJZ1?=
 =?us-ascii?Q?Le3LSBL7++8XYqZiiUMRXMbMPZjFA3LivGXfMfX/sUP+LA03ig365DnemrlZ?=
 =?us-ascii?Q?9qbRPUp6pamZxbdIIGCXGjI3n5AAB28hULuBSkPXgBwgs+vjbCUYkbG9MWHB?=
 =?us-ascii?Q?X3tqGzN1OH+gmZQI5oOqN1XQwbb3J8JUMYJMaZ5L?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca050d60-a27d-475e-9ac9-08db8d03dc46
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2023 11:39:52.4458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nxKk3DwDh3suPpYy1D5aLGcqiKAS3ycBERNS90Rp37KgQwBu/x+oyVdq0ayBFMNI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8030
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 25, 2023 at 04:15:39PM +1000, Benjamin Herrenschmidt wrote:
> > Assuming this is for #2, I think VFIO has fallen into a bit of a trap
> > by allowing userspace to form the mmap offset. I've seen this happen
> > in other subsystems too. It seems like a good idea then you realize
> > you need more stuff in the mmap space and become sad.
> > 
> > Typically the way out is to covert the mmap offset into a cookie where
> > userspace issues some ioctl and then the ioctl returns an opaque mmap
> > offset to use.
> > 
> > eg in the vfio context you'd do some 'prepare region for mmap' ioctl
> > where you could specify flags. The kernel would encode the flags in
> > the cookie and then mmap would do the right thing. Adding more stuff
> > is done by enhancing the prepare ioctl.
> > 
> > Legacy mmap offsets are kept working.
> 
> This indeed what I have in mind. IE. VFIO has legacy regions and add-on
> regions though the latter is currently only exploited by some drivers
> that create their own add-on regions. My proposal is to add an ioctl to
> create them from userspace as "children" of an existing driver-provided
> region, allowing to set different attributes for mmap.

I wouldn't call it children, you are just getting a different mmap
cookie for the same region object.
 
> In the current VFIO the implementation is *entirely* in vfio_pci_core
> for PCI and entirely in vfio_platform_common.c for platform, so while
> the same ioctls could be imagined to create sub-regions, it would have
> to be completely implemented twice unless we do a lot of heavy lifting
> to move some of that region stuff into common code.

The machinery for managing the mmap cookies should be in common code

Jason
