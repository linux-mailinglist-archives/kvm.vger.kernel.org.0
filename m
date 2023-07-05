Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCBCF748C0A
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 20:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbjGEShw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 14:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbjGEShu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 14:37:50 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497D8171E;
        Wed,  5 Jul 2023 11:37:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LCkOvuZDv0V2cLfFPDPNVRAusgtdH0uW21sg93U4or5IHTNEoApeZnfbMaI1BWa4EBhd4xP0HMxAGsaCZA0YVKzlCZZHjaLIp7InHR1PweIXX4mUS07KQvXRnH6FNMwCDQx6POLdC5stCZVy6pvg0GLPWWXbdM/xS313CNtBJNKjMZDn6skfN2SHHxLbJ6Ppdef+zN62kF9wP6ptpSvwP/YNAn4aZiV2xT3moY7htHwiucecsaz7uDc1gFbdM+u/dPBqrY8cfCSKCh+VT8+uu2Z2Dqg4/AMu4T2vecUxA+gTo2exB2A6Q/ZvpVB343cDqa6GuZiuIsOhwo59InmZxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r06oppFVdAW/1NyUnv/5OYhT+0VvRrG5SGx/NF5O6SM=;
 b=bRNBHK0CaUMpfYU1GeEmoIDEr6pkRUyYalsMizuunfgr05nySi8l/nGDypHx0VB4zGfwKKo8Bd/X7d23XOBHrJYkTpaD+LFcCjRkLqwTR49GyUdpHjXxIPy9rk7D5vJ42yLEvkCxc+rLJtu+ID88k0TvKvlSx5YpU/0mIbhQG4xBMgLjW+/K7J+EvZ7oXns8VvDNidovxb0sLOw//Y9vVwINmJk3KU3RqOsI0+d1O1DxrwBVjZU2x4iout96f4i1vY7QPuwP98Ud11JZSKjQpSGEUkYx/U9YRkQ1ggoyfmsX7HrViRtHFj4ZylQwWOkD9N12pMsMg7Z++7sbluoDIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r06oppFVdAW/1NyUnv/5OYhT+0VvRrG5SGx/NF5O6SM=;
 b=QHuVhXDHm6MuboxDxbRnCITnp1K4CgDVL3V5PYW2BEEusFq9ZRygSwFZlUJr8HfmB9tzvZF+PH/el0QVeEgzcSdPzQCcjNnNf6EFDMDHzmZ5lhCLjPTwg4LEBuKmcYk/ju9fB0HxmYnWDUZCcvBEpDrErEffWtgNJR6+mMP/CCybfjnkjrXdyuRihnkxUksd2KjBc6Mdg1puOTR7WC7HghcEe3VfTvattyIZe2SUcx/xbjSL6qpWWM9K3hcIu0NJuMLHXHR3o01d4qJ2TknCjd3iPS8cfSa1Asx4XO6vVD4z0YdTo4sJA+jt+QgB+qG5EUyd64j2v3tjTLgIv3/+Wg==
Received: from BY5PR12MB3763.namprd12.prod.outlook.com (2603:10b6:a03:1a8::24)
 by BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.17; Wed, 5 Jul
 2023 18:37:42 +0000
Received: from BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::8634:5f0e:cf09:a084]) by BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::8634:5f0e:cf09:a084%7]) with mapi id 15.20.6565.016; Wed, 5 Jul 2023
 18:37:42 +0000
From:   Ankit Agrawal <ankita@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
        Vikram Sethi <vsethi@nvidia.com>,
        Andy Currid <ACurrid@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Dan Williams <danw@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Topic: [PATCH v4 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Index: AQHZpLaxSTuRkhXihUusFX/7jkP6ra+dRWYAgA3LksA=
Date:   Wed, 5 Jul 2023 18:37:42 +0000
Message-ID: <BY5PR12MB3763A67B9AEFC48BAAFA9C5AB02FA@BY5PR12MB3763.namprd12.prod.outlook.com>
References: <20230622030720.19652-1-ankita@nvidia.com>
 <20230626100106.2e3ddb14.alex.williamson@redhat.com>
In-Reply-To: <20230626100106.2e3ddb14.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR12MB3763:EE_|BN9PR12MB5259:EE_
x-ms-office365-filtering-correlation-id: fe8ccf89-aad7-41b5-85a9-08db7d86eb1c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2/8sikv8oC8w2fXaWWWQ+W0vUord45XWoBDWElLSB1ZuGnQbK5jiawxZ8OBuh7NMmYEqIlR3xR9vte1AP7SkX4gcA7D7A0CPnIemZnsWRz6yB9aDaPfEOXDlaPwn9p1k6lTQRuVXz3cyBMbTPtI0/+GLpNrKikQ3Z8QEgUENhpDRs+qzWAgzJNmpMsYI1qKuwufOUVboA6Ph9NDqqTmklaoooRT/piBXZkvrkfid1KmE4AKxYeJ4mg+5wQohliexFIw4FfwCXOPwPYrKR6a61jyt1mYdleOhDhNsW2/RibXQwWc+2iijQ+COhBd3fXnkDSNy7aTaYHkyson30V+pE7ZsbkvLRb6ZsZt521WDxTX1gLsktBExsrRMmruFAV5PF9yETEVKKYijNGMWSNjKShKgf5W231Z5KfCfcYaJM3V/xFE7Cp/bY0i+aUiyTM05/3iBMr2b29b6IDkWWTpZbdRZKH88th5oMObkXmAGpzpmFQy5YjxkLtcdHOlF91jSNGSbCRILVv8JOGudRrmAFkcytJ52XdncPcdqZceMSoOmnd9ltsCIxkvbbmasULZiXJ4IVDcGbCrVYCcXZFS+m93fCZfgcwHioEZ7p0W4tWTRLrau8Fh6nEi/fp+1N7PA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(346002)(136003)(39860400002)(376002)(451199021)(41300700001)(4744005)(478600001)(9686003)(38070700005)(54906003)(86362001)(38100700002)(7696005)(122000001)(71200400001)(4326008)(316002)(66946007)(33656002)(66556008)(66446008)(64756008)(66476007)(6916009)(76116006)(55016003)(8936002)(8676002)(2906002)(5660300002)(52536014)(186003)(6506007)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gEbLvzpWFz5h4T1dJXTa8AHQThjgrtpSPCjzUCg4DHO+XEY77i4KB+cvkn4k?=
 =?us-ascii?Q?6+50JRTb+azcxygum5Ao8rZg1yFiXOvWm0lagMsCdK9xWyM9z+I9hokB7i9a?=
 =?us-ascii?Q?N86+t5G3tZLOMbvqvXCL6EYmxgfcVJBPN2UzwdE23QrN3F/B7Sm6w3QmF8Rw?=
 =?us-ascii?Q?Lj4CugP7VrorVLXd4QsT0oXRhu27yIS8ykfpy3/VVdsLmdA6aZbuXjQ4EEXa?=
 =?us-ascii?Q?3+7WfUhY3RfZB3GLcr1dnWdrG8WThVoxU3xm9zAKsM5w4+2PHncugspUpZld?=
 =?us-ascii?Q?dWV19FsBEHIIYl0Nxu55kBQhrv7xlAnqWoc+Qd/tsfI/60mPWToqjKm2ONa4?=
 =?us-ascii?Q?qbqQglOU/Z/PuXTsbV63nWTS9OFulY0cqS1VAIxxtd0DTHw7mWymw0QJzdqZ?=
 =?us-ascii?Q?9NNWUAGbLvq71Ckk26u8PvtwUetbfSGRryL2FvxFbReqieFuYpylUX5/Ane/?=
 =?us-ascii?Q?aXdbVupg6UDLCih5iV9iORjWdopvrgyf7afcagWo9Cbhhurhr3Q3UC/uIx2z?=
 =?us-ascii?Q?cxcaE4unHc7PLgB2Ra/8xH9f09b4SXqYD2/IFS6XG3fwJViFmwMT2CViKJYV?=
 =?us-ascii?Q?MTz5JMoOALQbEvzxLUbV5quzgsIoqkWIPMw/p5RKrtgOssB5Lo0jV2i956bl?=
 =?us-ascii?Q?PjFTJtB8GYSmY2NXkJvkdlKHl9skwlMoO/3Ec5rOFCUefHg5Vk8Uy8EiA5d4?=
 =?us-ascii?Q?oFxPhADeEGIgiAD2z1rjrQL3JEVRGcZJulh1ndlJqlBniveGjPGTbP6ggGcl?=
 =?us-ascii?Q?geKTk7xb/YAiUHqqwyNQK9VsAYwN9un5+sAt7nGi16YYCB0u7DlNAqPtO163?=
 =?us-ascii?Q?RwaNN8Cs08mMi1yd9YQOb02T11oHy3PIAYEXviVuQENzdC00coqlcGALUvGh?=
 =?us-ascii?Q?KOppAH/omqjw6R20p1+1rx/Jct7WRmLtTCwuWfnyOjPRGIsRMbHWXEjtw1PS?=
 =?us-ascii?Q?1LcFhz1aWFC7i2bs3KZj0TWUDSEKdQL+nZJIad4HpTnELk0p+9Ia9wkczvZ3?=
 =?us-ascii?Q?EX9czlvuY3QwMkpPQJCisNCpHHhcj3jtCZRRSitZSNUBsD8dcan0wzDy6ncD?=
 =?us-ascii?Q?18Ywnu5umN4QUkCxA8FpwNI4lv1qhsy3I6nQQ0XkrG4i7Lpfjuw/IHjLL/uC?=
 =?us-ascii?Q?2QdBZvF7AnZgcCz2IdlA7KBiMRNrdMoFTPxxbYyOUxIDELkntW0ZFrnQjDsj?=
 =?us-ascii?Q?Gwt2cQQESbB3yHXtCMZ+iXD1iFr8WdRO6T55sjCbPy7bFMORHC5u6teASu2m?=
 =?us-ascii?Q?TjotVOfNiwU7fYPg3x1d4ePSjqhF6MOP2hkDZCWcWz9atJq5iTHEbJPeQZXj?=
 =?us-ascii?Q?UPyGY1/ZoPTXwVlB50e9R2db4xO7gzq5jNbK+TNkHvxUJF5lERNZEY2sfD8f?=
 =?us-ascii?Q?b9ml2QTg1Wc++QnOb5X1/TYzD0j/7cM41321w2QW+KzCZCkfWO7/5mgu7d7s?=
 =?us-ascii?Q?hh1DD9HXqyalM5Fpr99keVGLXnC6kAgq9Ke4Zh/ymLDo/4we5vVvMAglWjA4?=
 =?us-ascii?Q?/OJteQQDtgljB+G7ZeKlEQEVuxRotlkKBTtlpriWPURgV3M33dlyHYqQmS0R?=
 =?us-ascii?Q?BpDss+6yp5Eg7NEVHRxO7u78TIXTalmhg0sGteVH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe8ccf89-aad7-41b5-85a9-08db7d86eb1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2023 18:37:42.6238
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8/HMTcy7dnwHXUVWOle9GEoFkLsk3cDbWVl6f1LQ9X6vo2oq2Yk4Gj+IZ4da3R1hLZcOk6ZwyaZE+xk1Fv3M/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5259
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> I had also asked in the previous review whether "nvgpu" is already overus=
ed.  I
> see a python tool named nvgpu, an OpenXLA tool, various nvgpu things rela=
ted
> to Tegra, an nvgpu dialect for MLIR, etc.  There are over 5,000 hits on g=
oogle for
> "nvgpu", only a few of which reference development of this module.  Is th=
ere a
> more unique name we can use?  Thanks,

Sorry, had missed this comment. Are you suggesting changing the module name
or just reduce the number of times we use the nvgpu keyword in all the func=
tions
of the module? I don't see any in-tree or vfio-pci module with a similar *n=
vgpu*
name, and the clash appears to be with items outside of the kernel tree. Gi=
ven
that, should we still change the module name as nvgpu-vfio-pci sounds a rel=
evant
name here? Thanks.
