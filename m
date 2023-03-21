Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 398316C3C33
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 21:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbjCUUuP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 16:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjCUUuN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 16:50:13 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2083.outbound.protection.outlook.com [40.107.95.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B8714EBD;
        Tue, 21 Mar 2023 13:50:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BufzpoBD6wmvmyG0q9oPUGzkubGtB6l+AInmAlnriogN59tVDUEQ/TJWO9kqdVBeAo4QLgAY0j7jI1OPe4cv/mT2t91jB5X+GJOQq5NaAIZPm404OIeuuQk+Ymh9RfafKQlWhtVZdgeqcVt9dqKnrdfXKJiwXowW4vvX+Gh4BdYps9ZG0ulaIPITkpHZ2TZnDbl0WC+T0a0jHK36GBCd+O85LHvNWapz4YGBS7SvWgz4BW2qVtNBe4d+MvnwuJcBidNBYLNQsjq6g8BaBpDLVFYZM/vokoX0L/Ab97EFVuzguYMjbpiSfJP2Ye8B45pZD/y7O9byDRYON5ZvhS+pFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gDuCXPTPUbIPoFotgtCXHNrLAMsyJZiAJEoQifet5uU=;
 b=n4w+RKzC1jV2RlBTy+TdpGP9kHjxNNw5Ynvjmqf3oQn1T753ig1Jwfhvt7fQ+AwWY4d913k4PtBMF2AtEvBh8/unCoZ5INE+mTiuIS8kChpbxZ4qXOdwOyde5kYe+NhmSsJGMSQPoYsc2nh262/DP0aywARIJyVANsPRyhNChYWy23Ig691ENwvTWKmRNrqbxXUYRYj58IYKLero5xker6mJe1BcbMC6cQDHEeEeGrDXWOR2dMMO7ejl1KYZ3ayXfJ+Zn4xj5Vl2iBGGk5MlfqINbWYIgD9vriJ83lFIMcwSb3UOHpIoTjAyE8/5Hth5NOopZyeCXy6ipthNGoQT+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gDuCXPTPUbIPoFotgtCXHNrLAMsyJZiAJEoQifet5uU=;
 b=NfPdnQ7D+9qpi9yGITb4sRE5GrghTKKxYrO4Uwu3iKcLg0Qzq133bz0JqnNVc7rqmd43Voq3+/OespWUe2/3RMjke1hsFHLNBTjylS9rt4rU0lhgwveiVqtR8/D8hQh4vlXqbHlLxuE97qao3+vHXWFcLk69rmzG0obUYKeIFDOq279kAeIsKVV1yYLO2BWC2d/rgQDJsZnLZGwux9FCQICSoykSpkFQ7/meJ77DhitDjv2F6z5italS3wpU8xjFIXXOuzQbLf1EwnCPKn8/g/IqQcdsAmPqhDjQqLZupvaBdzoyUKddJtQMVljh6npf2z8fjKFjfRViu95yWw3oHw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB7598.namprd12.prod.outlook.com (2603:10b6:8:10a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 20:50:10 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 20:50:10 +0000
Date:   Tue, 21 Mar 2023 17:50:08 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: Re: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Message-ID: <ZBoYgNq60eDpV9Un@nvidia.com>
References: <BN9PR11MB5276300FCAAF8BF7B4E03BA48CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230316124532.30839a94.alex.williamson@redhat.com>
 <BN9PR11MB5276F7879E428080D2B214D98CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230316182256.6659bbbd.alex.williamson@redhat.com>
 <BN9PR11MB5276D5A71E43EA4CDD1C960A8CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230317091557.196638a6.alex.williamson@redhat.com>
 <ZBiUiEC8Xj9sOphr@nvidia.com>
 <20230320165217.5b1019a4.alex.williamson@redhat.com>
 <ZBjum1wQ1L2AIfhB@nvidia.com>
 <20230321143122.632f7e63.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321143122.632f7e63.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:208:23a::25) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB7598:EE_
X-MS-Office365-Filtering-Correlation-Id: 82d3ceb3-d7e8-4efd-50b9-08db2a4ddc0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zqzZF55CJyHN7CddKls5mCcrREKMibksdUZ7+48zIlJfCea17eL37baCUjh5k+ETEXO8w+/F58Ito4tN7I+UFyNWqK2j0f0ZHF064PGuB1wh1/CbZlrBfRmZEYryDUH9oLeV9qOlZFbxCYL/LKuGtYS/Jhka/YoynmVljdIQ2Dv84rgrzLqywYBsJ3SG73ckH9FcM6sGBIcekcQF1Sv7qkBm8/XF5m+5Zg5SK8oH2LycbrWdCgk8vSGxxWmtqeQw1wX3WfIbu1lWB4eX9RIbIhNRJM+IjEZmaak/nWv/sjfP8nfR46tsH815NlAHky5ssEzS+R22B4iSLmnHEdGUs+L5ENaqaXblKGGeMOHDK53FQLoV2qs4+ROEOPq3CzBHm8SKjp4L7msMTR45jbCka4me04/ty0+dxNXRkhnfVxkZkcuVtVlav3obHFjVizrIY97qKzYSZArwAp413v5ysmeczgdAuFdtIv7AP74UPNfSV+e6zDzfenoYj3VgYZuJ9VeXypSVEs5w40hd4wOjgGVknXuyOnWi2lzZZBpmajIO0Zt03SUZsZEMRGA3DxaRrkdbLg2Zq+3dsiGDZwN/jvZVQdLo/NTbfBIfScHXL54+SD9HpEgUqD1s80p/aP85oV4p3M7BcS6wMAUJ1dNxcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(39860400002)(366004)(376002)(451199018)(2616005)(6486002)(26005)(186003)(6506007)(6512007)(38100700002)(86362001)(83380400001)(478600001)(316002)(54906003)(7416002)(8676002)(66946007)(41300700001)(8936002)(2906002)(66476007)(66556008)(4326008)(5660300002)(36756003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3iRhriUDAaDQWFylD6l06BBzB55J9ILhZHo+sK/OT+SVh9TFlqzAyQQH9uhV?=
 =?us-ascii?Q?ZW5VyD+X7eAhq+l2wnAmnkl3zfvlKVefXlgfU7u0b1SOXP5POGuEzCuwrUml?=
 =?us-ascii?Q?hWGdbhuxy+10kQ20lNAFZ+O03T3hUMCMEvXmVYXfHkX5g7ci6hG10WqhIE9x?=
 =?us-ascii?Q?Eg6cMsW6/2mbtXRa+Bae16r9jJASz3NS3JfHvEeShpmWl2Lsi7jqdESIi182?=
 =?us-ascii?Q?bdWrRaSHoFImR0JDJ/6m0LHlgfCczWYPFLpfXEdgvt3wSPdWTHsoR79EH/or?=
 =?us-ascii?Q?5sHUKUpjT/s1z5sRwfGpivikYDtp/Vp+I4pGSY7cWMsyToO+c/4Cw60tHC+v?=
 =?us-ascii?Q?yDFlzKybE2TbyJ8+9v9pC5s1VoM6IQOrEqXG8ydOvmmpBYGqdRh/diGaMEp5?=
 =?us-ascii?Q?HzIYq8YDMNW3fgya+KJBjA8UwBPaRJNYV/RfqgULPsR/N9kVfBeG5yCcPTTC?=
 =?us-ascii?Q?aYxO0+Sv5+xwNvfJr8VA7iLkjC6gSPgHSXmRP8ZaMzM3zb+1nEdeqyWydCer?=
 =?us-ascii?Q?yolbm6X/RiSppdGrfXzlx7Nj1hUSsT/drTNn0daGRtnvkkAOGNgEDqrvzVQJ?=
 =?us-ascii?Q?qCVKK/XyK3hHkM3ItDOjccH+/ibmZxd7O7USD2r3myR67ZthC/Mhw49pAroJ?=
 =?us-ascii?Q?57hzbSLTY0P3SAA85ILinZz1aEA0rfjND30wNdK7uwZ7DbE3o3hpcTlaTxfq?=
 =?us-ascii?Q?BABzCRlV+dgmC12Wc8MuTuALV0djdqKZqzuA0EMLv9rhVXoFuXdYtOXqr1AN?=
 =?us-ascii?Q?9ChoyGpe0yXJHpxlyPtquiwlSwA70M3563OZ/OisfbKRYlvE1KX1k6Dq1dvJ?=
 =?us-ascii?Q?HtdfdT3DiwS7rrUPp9GDI+c6afrCZs4eBmbdaxz00svLNRfzE0GAujZRNZWN?=
 =?us-ascii?Q?p8/ow5ncKaziPO4hkHzUKtolPkIrtIUHcJXwwAN+cSDLrVV2bsDvso8VaEtp?=
 =?us-ascii?Q?xTf+4PTsiLelB+tfo1RBgIXUrvsHrQTBQoQNmpCb87ubxtk0y2zomyy03VSZ?=
 =?us-ascii?Q?TwqvrxCD0DVbaaoL1q+7m1V/LYc1js8XRv4Bp+LXCipg0JP6hrVPR/O0vU6D?=
 =?us-ascii?Q?EHGmkmqIzAnSWGvhfOLjBOa2TmERT6wrH61sd+IC4hnxoub/vZtS1I4S3iUa?=
 =?us-ascii?Q?lcAcqlnSQb5RePKRmkSLyDtqJNyYRIPS6SV3ssrLdxdGMKJBJo5/hkcBrLlN?=
 =?us-ascii?Q?3auS4JTsrXKKzfO+Xd7R/pyK6DfCy4QBL6Ck5tGK7uo+l1fZJx0ait700gTF?=
 =?us-ascii?Q?jz3X99ierMO4o7D07CW40HDzexx62OSFTlu8ftFkXBQ7tt03OFkobeWsAXTZ?=
 =?us-ascii?Q?82MJGnZKQqqmL4Sq9fnodrDeCTFrB9iD+32QOmcAIFgdCGT0RaNRfyqmXlyS?=
 =?us-ascii?Q?3HsxIp4blpRErdi2S45CcDZfyZ+YiiZfb3BnLSgRk0uW0lRw5bbz7RTgEICb?=
 =?us-ascii?Q?AeeDbzRxX7oKmZcfQrFEPm7I5fNcEoPG2noTjP2mGolJIVHdt8MQS7ElIZS8?=
 =?us-ascii?Q?Y1i9IC/sGEZYIy+XBK+JFVJTZB6/VeLJcDrBrAZRqw+w7NI6aBCT56BTgvaB?=
 =?us-ascii?Q?hf5zrgkOVTCaQ06EOj/IlbYLZ2HRtVbL2WcyGCW6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82d3ceb3-d7e8-4efd-50b9-08db2a4ddc0b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 20:50:09.7977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cpBJUmvqwjZOBiMCDlyeFD4SMHmUn+WTF4QT+6I4+EHLTqP3rF5JHjSH31khCdhI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7598
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023 at 02:31:22PM -0600, Alex Williamson wrote:

> This just seems like nit-picking that the API could have accomplished
> this more concisely.  Probably that's true, but I think you've
> identified a gap above that amplifies the issue.  If the user cannot
> map BDFs to cdevs because the cdevs are passed as open fds to the user
> driver, the _INFO results become meaningless and by removing the fds
> array, that becomes the obvious choice that a user presented with this
> dilemma would take.  We're skipping past easier to misuse, difficult to
> use correctly, and circling around no obvious way to use correctly.

No - this just isn't finished yet is all it means :(

I just noticed it just now, presumably Eric would have discovered this
when he tried to implement the FD pass and we would have made a new
_INFO at that point (or more ugly, have libvirt pass the BDF along
with the FD).

> Unfortunately the _INFO ioctl does presume that userspace knows the BDF
> to device mappings today, so if we are attempting to pre-enable a case
> with cdev support where that is not the case, then there must be
> something done with the _INFO ioctl to provide scope.

Yes, something is required with _INFO before libvirt can use a FD
pass. I'm thinking of a new _INFO query that returns the iommufd
dev_ids for the reset group. Then qemu can match the dev_ids back to
cdev FDs and thus vPCI devices and do what it needs to do.

But for the current qemu setup it will open cdev directly and it will
know the BDF so it can still use the current _INFO.

Though it would be nice if qemu didn't need two implementations so Yi
I'd rather see a new info in this series as well and qemu can just
consistently use dev_id and never bdf in iommufd mode.

Anyhow, I don't see the two topics as really related, the intention is
not to discourage people from calling _INFO, it just to make the
security proof simpler and more logical.

Jason
