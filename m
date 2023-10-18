Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C30937CDCAE
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 15:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbjJRNHE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 09:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbjJRNHC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 09:07:02 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2059.outbound.protection.outlook.com [40.107.93.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F06710F
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 06:06:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iky9JQSsMh+C4vLRJn7vpBcQRnFRWu5nVD72I5VT7umzyLwVTNMHRPM/xGnA7hS23N6AiQ08ZjNorBoN4RE6hHMkyvPW8hEeFE+jibMydhkPmy5ABHu/81RjPwVAIT4TSat3GjAED7Hqs0NxNl/mG2O82Vjj/fUgOcNIIX5l42eh2DApVmz/6/4QpoLfdUOwqzXyGSKd22ii+9AB4VIozK7y3k84SRufBJrMA0S1N1T0j1QoItePUuobIg3gBaDd3/ndNsYBQFyyX+zQ868DfzlH+Cwbc8neswzptxftzdY7O/t0hgTGVttdyxoph9RGZOJrL0rL8h7El6GkPZ6J9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4jb5i2rgC/ifrapa+q616JX06hZYD08WNrg3JURDXf4=;
 b=oOEu6PJHpf+wXXQ4P0HqT0L/gPjabEUfRnREx0jZEwz79p3alqG19cN2RGh+8Kt13Ze3dZYhkh8gxmrIUFQVfCkGKwsWQxxTDokEHTFPXm8m5fcxswHWEC4W3Z1TcpCHYA878jhkdotD4pIaSN97df5Glu+47aJ/RyRIlrDzwlUD1wYdGF4juAMVfKLolb/3z05zBCEnk8CnGMIFEp013k6R4rMU9ryJqASPH2N920O4zBpojuwQncWrB960Gd67FYk3NT5wdue7FeeWxuuC+xhp/p4xFABvXWHMKK1PLd4T01qFMjkN+x2QVQwQv6WY4gUkBLkcWY2cQU31HeUB3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4jb5i2rgC/ifrapa+q616JX06hZYD08WNrg3JURDXf4=;
 b=EIjCJ7WaKiCg7MZ5Mnh58wtJXuiZUnSjH0VkeeIrhr9TEEyUXrb7N6b0FgQhddcmwJc9ErELaxqqniDs/3UwlPi4hYsoJOxYHgxiv81Pg8y6KKrrLGV6mzLkHt47a9ielf2dcz/m4MLpv6YEW+10AdQgQpRba2qmp4b6pY3jCSB+s/FGPlgOES65+bsNay0fEym7IWEDS2zheR1613/+zyhH1Ga7JBssgs2E/2ktN17vRgW6JDcFvOnSEyIC4wHmxW2obHXOrdCWjsVX9pv6D2V6DddRq0jkigNNmaD5ySy60XHH4yvVOHjd8UTAUj8x3dw/ph4rhsW/M5f3dymO4w==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH7PR12MB7138.namprd12.prod.outlook.com (2603:10b6:510:1ee::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Wed, 18 Oct
 2023 13:06:54 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::23d0:62e3:4a4a:78b5]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::23d0:62e3:4a4a:78b5%6]) with mapi id 15.20.6863.046; Wed, 18 Oct 2023
 13:06:54 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Feng Liu <feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "si-wei.liu@oracle.com" <si-wei.liu@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: RE: [PATCH V1 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Thread-Topic: [PATCH V1 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Thread-Index: AQHaAP/t3dG05nYg50S7FQsh4+CEA7BObfIAgADTjICAAEA8gIAAA69w
Date:   Wed, 18 Oct 2023 13:06:54 +0000
Message-ID: <PH0PR12MB548131CA6F0E5A7BE5B5498BDCD5A@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20231017134217.82497-1-yishaih@nvidia.com>
        <20231017134217.82497-10-yishaih@nvidia.com>
        <20231017142448.08673cdc.alex.williamson@redhat.com>
        <f6168335-d5e1-00ec-13ba-8c9a174b7eb0@nvidia.com>
 <20231018065151.39ee962d.alex.williamson@redhat.com>
In-Reply-To: <20231018065151.39ee962d.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|PH7PR12MB7138:EE_
x-ms-office365-filtering-correlation-id: 1361d317-81f6-4a71-94dd-08dbcfdb19e0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: alHEDqWymWaPrQpiF2q6MsbvySrYs1oACgSu4Giv9WC+guV4TuL/+1QvG4zdjp8WQnM1m1GlEq1KyKxJwshdQkD11L+l/rQzghKft2spKpWSyvX9skjqWVQ9oMYvnatp81RemVxjuxCbxlw3ikI7hkL7Zw8dwfYRuYVrn3rzHh6rzEre16ENRyUndQaG5tYUc8/nvhKyFud+p+c/FJYDy51Q54GohfRdTLr8HFXIzjV0HZjmist4XpgVKrqJdH/qnaqttXdnW+9N5PogRsC02XmZlcPTHMu69FRhfhhOTgA/SeaMVJuOiC9hhX4w7TCR7ca1gVeiDiEO1UjX2SuCogKyoOx98+CgzQHBkj3s5RofHsAJ8DUv03lF4gLaXpXncakQwqEyguTGMLg7QuoutrAZVvFSwMVMDVooGkg2Rv7jgZJYXoHh4G5LFmSuEy7ruW89Uo2G0rlXFvUFVzTcGPpPQRCIb8ZZQELYb3Tu05vWZlEsvEytlM/vQzorhLpgs3KUJIeRgX5fudrGdRzc57Y/xS6lyfflLJZvS4JOVzCZMamP6zE48PbrtYlyfDb4l0uP6tEsSFxVukvyNY7Kiv/oIUyrmrHviWa72e8lNA6MJ7VD+6QBazazJnWSGe3N
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(136003)(39860400002)(346002)(396003)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(7696005)(55016003)(316002)(66476007)(478600001)(66446008)(54906003)(110136005)(76116006)(66946007)(6636002)(71200400001)(83380400001)(64756008)(86362001)(66556008)(38100700002)(107886003)(9686003)(26005)(6506007)(41300700001)(52536014)(33656002)(122000001)(4326008)(38070700005)(2906002)(8676002)(5660300002)(4744005)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tVGswpGQAyUxf/lsld7FBwjWSf9gNHB74IUK9mqQ6kpYHbh9Cl/bgCUQD7Pl?=
 =?us-ascii?Q?DgRVuU/QpJhc/i/TtZOGtL8N3OY2KslLX9mIy9VeffYbBBu9/p3d53+CIgSR?=
 =?us-ascii?Q?pyFucvAjd3LGdP/VZlP6YYxvwQ7UkWII7kh+sCwgU/hcq7NWCdsMMn3Xa45l?=
 =?us-ascii?Q?Tzq9RFkeqrlQ+Sf2XNCOYtSDNr9ee1IrY0RPxfC4RmAzJ7/rXot4DID9ggYZ?=
 =?us-ascii?Q?4RZDgC1wZJDtfTQlf1UhVdwRAW3/Uz3Kh/GOJBOtM+E+mfOUUlH/KJ1QoJtq?=
 =?us-ascii?Q?3TxnGtMXZyANNcA4JdemUpERfF09sgstz4NSPFktgIX/OCTx+r7PYuAIMOD/?=
 =?us-ascii?Q?wJYdZpe/bNqDMpv1HBUd3CBuSjs1/6GNnWmkjWjICz+Yzed6E9TjSIjzmfLG?=
 =?us-ascii?Q?GHBu9jFNhmznR9RGZgl+OEOMYnWxOuARsgWYUVeMcI0CFEYPu0XevN3xzLd/?=
 =?us-ascii?Q?sK9lVTnN/EuDT0qKvzgnbGQjgkNTvOuIlXFGx7EVklcUDlyfNgPHMMfQVUc2?=
 =?us-ascii?Q?HjZgNIybBYHKBy/m9P2GWxw6mQeelZXTgAIUKFbr4quDBxbUMaW1jdqAw0Kn?=
 =?us-ascii?Q?3eF0IBxT6pr6MutSzzIU+tIWR3zkSHzldkZsVGd5nGMNlOTJZCh8NIuhhaXB?=
 =?us-ascii?Q?VCnnPoQq5V4sqPcTw0IGqfyJRV2lc1LwdwKbEhWQe080llv+X11DDsvdLD1p?=
 =?us-ascii?Q?Zq7+wwynUrJwlDcoVVfV+7QIIUIhbHlZ4lbegLt0Gda1s6Bt0VAwPHjzuZZq?=
 =?us-ascii?Q?E8xTZNvhYqudnn0IEcLrdCkxjTPCVI4ImCnZIw8l2bQZ0lpkk+nVvSyY+NZY?=
 =?us-ascii?Q?uJoHLgmiyTzn9mu1emQYs+S9ILD8C0AepSdcREJUTBoUpSTw6L9JYEFKbTwO?=
 =?us-ascii?Q?vWlBZDxUr9yQ1PRwSJU5FdznPB5WHGImwFca5aOOxy6TGMNT+2ae+Mva04eh?=
 =?us-ascii?Q?HA7dWWTLrMhx3W1C+JslqGnTEw2N/6lYvevDFschVk+OqW01noZ2b+KOejrk?=
 =?us-ascii?Q?/W8YrOI4jcND6s9/5IfVxOIBnHwQ+irqsRR9PIr8/b4rPt41po+2b6RsNeIW?=
 =?us-ascii?Q?egr6EX79R9EQIq5FI3sm/Nvm2ZpDj6kM6wXGCdj81/QLHM0jsVnwQ8hnaUNc?=
 =?us-ascii?Q?dYAjoJ6QJKVwa7q2gV99Tr1fx8van3yY4GOqexPZFidwEANUx3PwfQuu/JLu?=
 =?us-ascii?Q?KNDSFO723h8IxsLCefdqv6+PFKSO9o+r36nZE67KJ0vPMFzQYwSMJ6Fnvie1?=
 =?us-ascii?Q?TN4WF+q2yaDAt7Lcxjvnez37FUre7zD75HsHfW08oQWaCwKwo8r9qvSGn5bz?=
 =?us-ascii?Q?v2MvlbQRs70VyrzwsOdvPeCkAi1PuWexKIBsomZCAyok9Ib9Eu9n01hL2Nu4?=
 =?us-ascii?Q?sk8FNZ/3NtMvyxPwwj3RhEaWwVGjTIkgvTWSU5okrF6vwMtuXPB2c2bhqAdR?=
 =?us-ascii?Q?IMxubNrtgx3Q9qhksVrD91aOV8Tu/6Gvvjfy3qKJPt4s3Oy8i1IOhNfZqocR?=
 =?us-ascii?Q?HZCQ0WGaUkRUqp0wQkpRKRsP18QC2iKGCuIg1sM/mnTev6/1ThfFmQwVZcmP?=
 =?us-ascii?Q?0lqQdtwDP9+arRdra6M=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1361d317-81f6-4a71-94dd-08dbcfdb19e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2023 13:06:54.1569
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5x1vVGY7Ar8AIV3OYybxsIvAWdh3G8KsYdQN51wRbx5bQ0Rb3eYOvLRU+pKJg8ZbjOu4MSmR8qUxcc4KQ80ANg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7138
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, October 18, 2023 6:22 PM

> Are we realistically extending this beyond virtio-net?  Maybe all the des=
criptions
> should be limited to what is actually supported as proposed rather than
> aspirational goals.  Thanks,
Virtio blk would the second user of it.
The series didn't cover the test of virtio-blk mainly due to time limitatio=
n due to which Yishai only included the net device id.
