Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C59EE4D87A7
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 16:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240968AbiCNPE4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 11:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235147AbiCNPEy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 11:04:54 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2054.outbound.protection.outlook.com [40.107.94.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1CD3D1CB;
        Mon, 14 Mar 2022 08:03:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WMNqcHprSPjfvFpdKQzgsA3weSJglo/FphreohFVg/1g+lQN3tuLlXaW4STobJcHPo090ZFb7kjVGlLgUhyMrqVnhRDCDHaREhBO9vjP7qsHySIzZWTFKbnk7JXCgxT7GiiFQ9zai/YH6KS7WkOB6J7Cfm9lOURFQaxTXt7r2vpMTojCZY8Ah9b6srKQdbz5Q86Q5qGzDlXaP/yqVnq4YHrmZIL88a2VhIcKew2aK9nQ+WJPPNq4oKEfHFkxgP1dfUH6cKCHpbrf0Tvizdv5mokvghU9NQEM09bmUmjQ+K5ZX6CKXo+ErJQG9XbWA2mGYHWWtt65vGRtk7ZM3lf+TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kJ8aWSlHPgQDMyq4D3N2pdzjFkaCvtNK7VLsYMrmbIk=;
 b=C+/qXgoYgupQYEo94gO2UjDn9BFCcjElHp91GyLNtSRkyvV9Xm8HXqTYQU8kE9vXK1B08SEJZjn1AV/skX7Zmybytzs6maczk0KoAOF7a6xyxwMMZUZSAM+lCFiLzTZfU6YHMlHSl6MsDOdwB12BU+8OSfUDxbPpIV2FH3xW2xrabGXwJymS1zV2PQ3RZTNzvYQ5r717sscr3qoAJ0cebEHJ7SpS3PzvWm7Jc4oTL7BhIVa+LK/VJdD4TwotsTdz2NYiWmKaanrQS09I5O4bDIYPXQTkhoM2Lubx0DmkLdBFU2HP7noxLroXnmISgXJKhFhEuijDrLBFL14rheo68w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kJ8aWSlHPgQDMyq4D3N2pdzjFkaCvtNK7VLsYMrmbIk=;
 b=idJBTWRZpjs7feB5K1uBQFzoQ93m6T47pWQ0rubRv52K9rZ6eBfMjtGTcU5nX3/X1aYZU33TuDmZzF1dKYwgQ5HRTpGKCZOCb2tvNhCPmgK1DuIoaMcOckJsrsTc080ZA9KsJwxk3D8q3k7VFChYiW4w7K4ekdHz8dQ4qqtw3BctzCxikKMBDnUkOnGXE2iQqxWjHxpAqMJujzKX1b+2U7cpl2DEwhXMpsXuo3S9yPdnsYB4t9BHzo7owJT+T2FVqclaTLrlSkNfmwfzhGptqFoxI92dNhzq1AWNzBi/qTl/4MyW3DdhW84SiVqq9S2q93+r0wsdcC6eZxxh13H7Gg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL1PR12MB5112.namprd12.prod.outlook.com (2603:10b6:208:316::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.21; Mon, 14 Mar
 2022 15:03:42 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28%4]) with mapi id 15.20.5061.028; Mon, 14 Mar 2022
 15:03:42 +0000
Date:   Mon, 14 Mar 2022 12:03:41 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>,
        Xu Zaibo <xuzaibo@huawei.com>
Subject: Re: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20220314150341.GD11336@nvidia.com>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
 <20220303230131.2103-9-shameerali.kolothum.thodi@huawei.com>
 <20220304205720.GE219866@nvidia.com>
 <20220307120513.74743f17.alex.williamson@redhat.com>
 <aac9a26dc27140d9a1ce56ebdec393a6@huawei.com>
 <20220307125239.7261c97d.alex.williamson@redhat.com>
 <BN9PR11MB5276EBE887402EBE22630BAB8C099@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220308123312.1f4ba768.alex.williamson@redhat.com>
 <BN9PR11MB527634CCF86829E0680E5E678C0A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220310134954.0df4bb12.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310134954.0df4bb12.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR03CA0035.namprd03.prod.outlook.com
 (2603:10b6:208:2d::48) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8303c6ed-abc9-4f2d-18a8-08da05cbd422
X-MS-TrafficTypeDiagnostic: BL1PR12MB5112:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB51128CED82C1AE5CF27E6243C20F9@BL1PR12MB5112.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UuRaeAkOFl+GnWckgNXRc77J2WofDTefZhZQZIIqlC0Ah3ECNqaaCyMbk4V+0pbXqRlC3eWmDBt9DDP0RO+B2ATXLLg8f7fvhlzr6N7Tj9fgMku9ZrUvVRI7iR9LOzVcSK4a7ixTeGDlG34AdRFjRN19Wwhiid3uqQGTLofiOjsZqEYP6uCkxBPZhAjxVFYtlMvbJSAjM0lOE1S/m4ZTzxg4mM2myvCi8gqSY++D7myjCiRGnRRNArqwlSuuBHtib3O45eoVIHDbIURB0XywvIpGQx2p4vZmmxSFtmed/tgkUEQwqneh2aJJFT0LQABJk7KjLlqQTlLMSsAV1L0ylfgUaebnZxv5dmHlrhRLaNHK1wbYsGPwzl6e8UADkVIoQrfutLGwbyACl5jMcLbFPkxY39ywiGKAaBDfVdU0QLjO3exbV+6bYyWv2XKxyh5N2CEdrbNdcTft1fNZyP2icxmTejOl5g8m/pjDYMUJm61Jwm+DJ4b130HS5xaaHzDKOG0BZ4dccc0jW92dp2zXhnDmvZfi8bcK7mOvJD9nn5Z1GBXDAvf8LB8ytxiTNgj6VxYW2D52+HDw7ZE2B0sdTA+E0F1aeY3O9ytSVboCHVhhMaA2nCdKLRil1CIJyA+JaoTzwUrZ1yVwHcY2Tw3yoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(6512007)(4326008)(38100700002)(8676002)(66476007)(6506007)(1076003)(2616005)(66556008)(186003)(2906002)(26005)(83380400001)(508600001)(316002)(6916009)(6486002)(54906003)(33656002)(86362001)(8936002)(36756003)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HmLY0k539fDXQnpq5mULd6zlayrOFsA9GD7+74Q+A9AJwnpDWyordNMvdvyE?=
 =?us-ascii?Q?TBup0G7XAN5uJLZWaNw0k8rGCT5Hm3EJdT/cfoxKkAYrgUhjMwEBzdQEWfxg?=
 =?us-ascii?Q?RAoO9ylqNVUk7aDB46ldSGdP1RA7JyNd73T6tzDLhWr4JISMEYK3PG+ophT7?=
 =?us-ascii?Q?h4Nmpv3xabHGjBd7mrbDu5RR4todAs1YNUo41fUikPTDFUtjwuU8gtBN50T/?=
 =?us-ascii?Q?wDnrG+h2kjZZCSqlKgeGDUG/VspE2lTw99lv9sPWNZvtDLBM8MnHk/8IPVWM?=
 =?us-ascii?Q?2e6KP0CaVevMfEhCwY1s8/Pb+4qIeuPiYJ0TIHkxvWUczmsU2iaK91u16leX?=
 =?us-ascii?Q?CbAnGDm3fSROl0V8t/v1YWcNi2/Wa3JQI7ywlw6AuG+Aqvt8qfptQfZMr2kn?=
 =?us-ascii?Q?Wa5vNJGG216Qm+m4fURQjPqLi758QrCdH89jPKs+OOXjEPJacXmoPJ+q8VvH?=
 =?us-ascii?Q?PlglsOQPQhMxfWvT/ufr9hp63gBRDXFEDMzWAUm3yqAZI+0HF7iBcoGJ/ILe?=
 =?us-ascii?Q?NKenoL1wLvY9FmgOAJeoG+TzXqoX/nWz26NmldUPjr741iXqH1G1nca4QCk8?=
 =?us-ascii?Q?ghqDwzBm4YVbAM0TujvK1KhEkEnT0SHIemM92m/PuPSvJPmsqZ2bIg69VCKT?=
 =?us-ascii?Q?cup3cI+PdLJIixme3YWyP4777P+o103+wfpMJtEkqhfquLLDi19l0L5UikoT?=
 =?us-ascii?Q?TuXONBXsMA1+G3SOb3bDVjaNNZIKBDXSNXfMHYzTNGbvNmFf7hcHULo0pxbm?=
 =?us-ascii?Q?wOyeGMh8YVsYVEIp69MqGzM3rzcjQ1or/Gn+6tUqD1acw/EsyrgAIb4rulp5?=
 =?us-ascii?Q?RTixU+4rjwGBIOY/JAuPnW+ofuEnJTm8f98v9ltu6IjRHTMmR31UswzOlnF+?=
 =?us-ascii?Q?YjJTK2UclCnOrbolywtbxIU7sRyWFZs1RQyGFBpocQO3yJKsH4o77kwQmlLn?=
 =?us-ascii?Q?r1s9aDz4nWWOP+0ARC2hd802vEsbkMQqqmyv7ajdKLjU6Nr65AT4cXL/2M78?=
 =?us-ascii?Q?w5CO4Hrdp0Ixx0pLJKd34J4m+1UjPUl2z01gNZD+NnHZNemnd1RIxraNoB+/?=
 =?us-ascii?Q?aVUl5h9sNEL/Ti8oNGX9UuE6r0t4VIyNw5fBqiPl8EyGFbmza7YQsB8TAp5j?=
 =?us-ascii?Q?XH5/CG/zSOor6/c/luLwXajA9cgNSkzbqjIGk9PDACT+v9GGRnK1SzLTpGMG?=
 =?us-ascii?Q?GD57kzSrZTosrak9EkmFgAk8BC7km/CCR8bvKpYEzXVH0TCJw2h1RSeslIlr?=
 =?us-ascii?Q?hhVmNC/H9KG9QT4ttW5HegARESabpyPAG+xdnpm21mU1TMEkUqC2MSnEGGNn?=
 =?us-ascii?Q?+eo2TdvZQyswP7vfNl5MdY5vTstkU1wTQS9PKTf4C69WTmfotSbMu0s65QNo?=
 =?us-ascii?Q?i/oU9S0XnGB0500sMAZlEmRDfMjwELPxcENLTUnJrOyUhddAYAECgJ11qyyP?=
 =?us-ascii?Q?Xc8DHFs8kLxIfmnfVOfFCG2lO7j3vths?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8303c6ed-abc9-4f2d-18a8-08da05cbd422
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2022 15:03:42.5456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y1Xav2xsjZCZ6oVjEb/mDKV7Hi9gIXHXQi98r3bqvLWMNjGgAkLVyEdML9DrHnw1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5112
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 10, 2022 at 01:49:54PM -0700, Alex Williamson wrote:

> +New driver submissions are therefore requested to have approval via
> +Sign-off for any interactions with parent drivers.  Additionally,

Acked-by/etc.

> +drivers should make an attempt to provide sufficient documentation
> +for reviewers to understand the device specific extensions, for
> +example in the case of migration data, how is the device state
> +composed and consumed, which portions are not otherwise available to
> +the user via vfio-pci, what safeguards exist to validate the data,
> +etc.  To that extent, authors should additionally expect to require
> +reviews from at least one of the listed reviewers, in addition to the
> +overall vfio maintainer.
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4322b5321891..4f7d26f9aac6 100644
> +++ b/MAINTAINERS
> @@ -20314,6 +20314,13 @@ F:	drivers/vfio/mdev/
>  F:	include/linux/mdev.h
>  F:	samples/vfio-mdev/
>  
> +VFIO PCI VENDOR DRIVERS
> +R:	Your Name <your.name@here.com>
> +L:	kvm@vger.kernel.org
> +S:	Maintained
> +P:	Documentation/vfio/vfio-pci-vendor-driver-acceptance.rst
> +F:	drivers/vfio/pci/*/
> +
>  VFIO PLATFORM DRIVER
>  M:	Eric Auger <eric.auger@redhat.com>
>  L:	kvm@vger.kernel.org
> 
> Ideally we'd have at least Yishai, Shameer, Jason, and yourself listed
> as reviewers (Connie and I are included via the higher level entry).
> Thoughts from anyone?  Volunteers for reviewers if we want to press
> forward with this as formal acceptance criteria?  Thanks,

I've not seen such formalism before in the kernel, but seems like it
might be an interesting experiment. You can add my name

Jason
