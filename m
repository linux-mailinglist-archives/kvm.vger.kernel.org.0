Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B28B5FC7DC
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 16:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiJLO7p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 10:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiJLO7o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 10:59:44 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163473894
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 07:59:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cFJaJob19Yeq64ahGO4dyV66URkExKMp8h79Lq81EjfbUDz08S+hYVkyK+7+9yWc7XHe5Sm5XZ2KDKUHSC91oKMXzBF8PRDaNHr6ATZvhEdnbP6nfY2atJMMMQ3zr1e3dYB4lfUNUKCNtTS2UmztcN5i/Z+4ueABm2hRVR2ANHJL4jlCyIeCI1P2cU+g698YHa0Br4fhm7yJ+3mqMh9xpP0SIsop4PWx+fVP5pKuC6nOKyK9AOUuCcHIdPJNpHCe4aifHJsDYJ/0utXiXNbF+M6PV9tYCNMoPk9HP72WbAVxpS0FmEXORXeU1b+UX3ZVC815hIqTZEGFq11/EARdag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+C9/qL97aZfnNQWr8V4QAxUt21bWPjM5JeFK46lpgNE=;
 b=NjdD1ZoznKX0PPboPBivooJ2KuUXL3NXJ94Srn57zj7psZiv3UbNIDQ8TCDXpxjZxwMFWN0VpuKGfFXQdDjR/nVX+PUrEoyPZI1O6YWRGFHU34teYCP9KW931jgdjuHyhTUSul3yGdU42U1tGsNGFFWVjaF5MkkF8hHxkPvnkRuZFm4nceitfAbJu/PsMnbdvyibloyQJk9tPsOjVxrQRR7zGYc06HIRIWG4kkzOwu+CItzk7vu4eWU4jQW6Q8Ik65v8Qz6KEAzPnRpTcs4USOe4gF2jk+swLEwo14/iqp0SKPZJqN42GX+AOINeygreLUfZt7b8KVkLz45VOhK3+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+C9/qL97aZfnNQWr8V4QAxUt21bWPjM5JeFK46lpgNE=;
 b=Dn2PFXozboFcBXi3tKIdhqpghw6dk078UvrlSJKH9lFajUukL5RdUJqsgMVFXGBdr8V/S5wzCCPXuhsrAfmksdlTu9sP5BZeihwaJnCFxWBHJsukV++clbpj0FqWb+4F2m/7DyVL2iToLBvHylXum0iJGqk3xpaQO5CEFF8Nc7SNXIrq8vWjZk7rHFn0kYH0eQe8QMZdndhADGEv7hPkUjqnYJ8pZtz7UhGCURvXolKxuELaBoxwuDeZxdsY1asyY16wJFyxdvvHBvueAlOn+uYPRv/KiXuqdN8pbji+m2TXPcmDnmLIBHHhHlXR2/5ums6YhIa0zk+bQ6BSAz2c4Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB6091.namprd12.prod.outlook.com (2603:10b6:208:3ed::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.32; Wed, 12 Oct
 2022 14:59:40 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%5]) with mapi id 15.20.5676.032; Wed, 12 Oct 2022
 14:59:40 +0000
Date:   Wed, 12 Oct 2022 11:59:38 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Farman <farman@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        Laine Stump <laine@redhat.com>
Subject: Re: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Message-ID: <Y0bWWsbhMbPw/6wz@nvidia.com>
References: <2be93527-d71f-9370-2a68-fac0215d4cd4@oracle.com>
 <YyuZwnksf70lj84L@nvidia.com>
 <Yz777bJZjTyLrHEQ@nvidia.com>
 <0745238e-a006-0f9c-a7f2-f120e4df3530@oracle.com>
 <Y0Vh868qUQPazQlr@nvidia.com>
 <634a8f2f-a025-6c74-7e5f-f3d99448dd4a@oracle.com>
 <Y0az8pNrA9jOA79k@nvidia.com>
 <f9e6ea0b-ebd9-151e-4cf6-6b208476f863@oracle.com>
 <Y0bR+lJ9Li2E/hfJ@nvidia.com>
 <f9ebaf3c-acb6-b260-6b97-872d52568bac@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9ebaf3c-acb6-b260-6b97-872d52568bac@oracle.com>
X-ClientProxiedBy: BL0PR1501CA0002.namprd15.prod.outlook.com
 (2603:10b6:207:17::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB6091:EE_
X-MS-Office365-Filtering-Correlation-Id: f7015484-fbc9-437a-0446-08daac626327
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3APCqeef2dUj4RR0tKidMjs1cNil6plhIcp/cK/OOCTyarB1CgUNAlFLvMsr25EIJzUmJNmK/xPtUFVFRHu8lZf1sDQFfTrT8ZFImn5dUAOsYE4LFSIo4RsvhdRfxwXicsRf1rmvq3N/N9rdge9evfx/rj0vFYUUK+nU198BKX2LeUC4u0A0c/a5iemMIJQKjmPHuGgeQ/466JlCeRUzxWoBw/ku3ypNIeZdBPUnM7fk92/xDaKrCcADsaBzUnl3cNPxqeR5Tz0u0zfuXn9cKEBLA6Zvr1mUNgnS2cbKDs5u/qPPsQ0kS4J3JDvVKwxLZM8TvqL/GLyw2gHsbevgud/gphkERVNvGc9SzSEu/ihAELheJoiPwtUWAxaZT9I09cRXsdTKtSfVEQOs9IZfqiZ6vHdhM3Rek2gPY2R21fqpU8rIxKsPOlIlQNL7risG24cScM1lHHi0pSWVwwzMs33YhAq/wV85RCr2TIxAF8YTeetBOnme/SNJp7iwA5PWg/0sF90gmsxD9qLK/VxruSWXfZYMbAgBWkFc1EfcKV2H71veLo8QKB2P3iAVBqya14XkXvYK/Ja5VDgG8UCeDf+6jNEw4z/PQrf1epHdaT0nIxPg56ImXqZl3cu2XQcfnVSg/ti/p9JhEGQCmaYdIrIcAkmhiMK6TDMH2s4RdIJKZ2hVm5249s16xEyv7YOfyLd8UFJVyXlVGm5Vh776RH7LbGktV0PxvXwDRCPOA5RLxZm98YKvVBvov5IkH5Ig
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(451199015)(66946007)(8676002)(66476007)(4326008)(66556008)(6916009)(54906003)(53546011)(86362001)(6512007)(8936002)(478600001)(6486002)(7416002)(5660300002)(316002)(38100700002)(26005)(186003)(41300700001)(36756003)(2906002)(6506007)(83380400001)(2616005)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sta0auvZXZv9ueQlMsQJdKrFFCh55b4QQql+xfxxzypW+NdEmIzGPA0p5aBk?=
 =?us-ascii?Q?PBGLXASQhU2tfFIKlYWBQ4dHnkoicqtaoadiBNgW7vN1OTlfuZIPT2TXnlDi?=
 =?us-ascii?Q?8bS8CrVuliYA8LnxI0VaBoiEKvfT0HPEsp3NkSGnC35Ez62h3pS6lJII3Bk6?=
 =?us-ascii?Q?azc5UqpO74SvDBtEtQWBTS33wXhfbqxMMCIrYgcHLb5FVSyrnFRLqd551F03?=
 =?us-ascii?Q?Sda3tPUvE+4OjJFyhA4wpR4W17kiz4bQCF+Uvo9VQowXymhY8G4wye37dq+7?=
 =?us-ascii?Q?f/EEtEVq/kwy9m8KRLnyrE0JnOEEEwDMw4WyXTft+WGqGvKjQe1/E6dt1i2e?=
 =?us-ascii?Q?wvXaTW0YyUqUENhJ9uloZ9C0OKjKKlRIB3YNQH0etkPXhgr7NxOFHdfzooy2?=
 =?us-ascii?Q?aBPQStsBhQDJNFYP93bi/O0vB21pXKGms9+yl/8qo/2+51gvJ66jcZFo2v9H?=
 =?us-ascii?Q?Ey3ZmIQBL4y76EhZ9ty8gwrCA4g+yFWq9EcXCAAUcUh2Q0pqR1p1OEWUjVcZ?=
 =?us-ascii?Q?TwsmKISu8AUbdysP6YfLBzk139oT1nhRKmyqM+8bmi63ZxsWdNlYKmP26pdf?=
 =?us-ascii?Q?1kAkX7ycRPkW0YSFYhvZnCrUsgiC5C6D+cmoL97yI9GswZTIyXZAEwk0JMCm?=
 =?us-ascii?Q?B8nSIKOuhcdT+NDFJQoxo/6cuLjCCQMtOflwQFeMVCJZ/xS7PdPQy/3IIEu0?=
 =?us-ascii?Q?MbES+Fvrz+TpQ0L6Nm0vleZpSa6gZ5FFuoTG8KuJj450FXLj6vzqujlqtTVS?=
 =?us-ascii?Q?C+1fDTZi1pN9VIlyWOidKWkXQakjXiGM0YTf0d8Oazd3aANczPz0ksiIkD8h?=
 =?us-ascii?Q?rkd7zzsCeCXznfv5xVznUfiNLxb89JVwDL2c1p7rChAnnhyu+++OpwFOgZxB?=
 =?us-ascii?Q?f6pX0nm62yqG5xGQqcSs5S28gywolxDTQXxItlIeXNA1r/0+CaxMp0D2FywA?=
 =?us-ascii?Q?GIkdmZwBBjV6gk/Aa1j1mY1VrzBv0Z0MXQfGJheDydNIiL1ScqXEpMsK+jTM?=
 =?us-ascii?Q?JDlCnBSlMs+AUU93ucH3k+m7R0JQ923FQbZB0cTBBBtHO4ed+NkhAyzdjqAt?=
 =?us-ascii?Q?62HH+WBHXTQawqj9SLfpPGXFUTVSyJzdPZfg00g6imbvwl6/9pyfnDD47ajr?=
 =?us-ascii?Q?at075K+TwFziJOovbjPYf/nFoGrES/Ri6l2sOQFE/YWM5wlreJJ1kaUpGIwg?=
 =?us-ascii?Q?3vNal6xtIGuRc/rpfQfx8QXV3KV5NkZAaC/HGBff7Cng5+6vOrRaKCGRigEo?=
 =?us-ascii?Q?3M6gNjQflqMKYKeXTkmWcQiDoVuQqBC4RVs3x6RkF8YlfwiUZwpHKeffmc3K?=
 =?us-ascii?Q?3QojsGR+4xcKL3WDruu+/wKeQ7SE45y0dk5FZooTEDGPFkOwGA9tGv3G1LdB?=
 =?us-ascii?Q?3bEGlVlICQgbskr/aDQla4+t/zHTf+LwT2EQHh3GXBL72gHM7z/xlYVZqVqb?=
 =?us-ascii?Q?S6UYIZAaARSALhi2jrCdNc4w/Pk3Felw5x5jIFzq/wiTo1tJq9EWmO1BRgzf?=
 =?us-ascii?Q?TSlmLqW8tKv5DwYjLfyuL6oQdDpv3AgpvUzyW7x6btVcRCbovjLixyPAEgow?=
 =?us-ascii?Q?1nS2Lj8sqq/gbqosINU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7015484-fbc9-437a-0446-08daac626327
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 14:59:39.8963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6+tBu3+KXhQQOO/MgXDSiYiSBcxNdjQezBbO7akyy5EU5sgv1ObpJ2xEluTE/+kv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6091
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 12, 2022 at 10:55:57AM -0400, Steven Sistare wrote:
> On 10/12/2022 10:40 AM, Jason Gunthorpe wrote:
> > On Wed, Oct 12, 2022 at 09:50:53AM -0400, Steven Sistare wrote:
> > 
> >>> Anyhow, I think this conversation has convinced me there is no way to
> >>> fix VFIO_DMA_UNMAP_FLAG_VADDR. I'll send a patch reverting it due to
> >>> it being a security bug, basically.
> >>
> >> Please do not.  Please give me the courtesy of time to develop a replacement 
> >> before we delete it. Surely you can make progress on other opens areas of iommufd
> >> without needing to delete this immediately.
> > 
> > I'm not worried about iommufd, I'm worried about shipping kernels with
> > a significant security problem backed into them.
> > 
> > As we cannot salvage this interface it should quickly deleted so that
> > it doesn't cause any incidents.
> > 
> > It will not effect your ability to create a replacement.
> 
> I am not convinced we cannot salvage the interface, and indeed I might want to reuse
> parts of it, and you are over-stating the risk of a feature that is already in 
> millions of kernels and has been for years. Deleting it all before having a
> replacement hurts the people like myself who are continuing to develop and test
> live update in qemu on the latest kernels.

I think this is a mistake, as I'm convinced it cannot be salvaged, but
we could instead guard it by a config symbol and CONFIG_EXPERIMENTAL.

Jason
