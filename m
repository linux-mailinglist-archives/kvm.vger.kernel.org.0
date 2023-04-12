Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 101AF6DEF97
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 10:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbjDLIwV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 04:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbjDLIwQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 04:52:16 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20619.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::619])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5F35B92;
        Wed, 12 Apr 2023 01:51:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NZqoGNjY9xqLhnSHRnW8BAyMjwScyJKTuT90POWzxeBVxOYczLbqFepZ3uV9BYKV0G3MV/pFjjLHdST9vt8gmb6ilS3u/aA+CtAAf06WVLjz1LE+yqd6nI4UyeyaoP03mZY1pvs1UAbdXz//rvhN8/GH8z/i1NtSppQBx4wpgo3Od3ZSqKAIHbaxWmxu8tKLUx9vNTc5LxPmzU1XjkvwETbEwHvxHlyooHxavYsCkQMNh9N4OtpW0UaDsOFWDdf08VniqLpVEY3eQPRpQyTtaoWBogi4ILcS/0CERJ+3XON/E3H2tC7eBozF5oKWrDnjK+cGcRRosAOVJWgAWHr52w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UVYTdv20euefFjKileWXPWGMT15CFlsbzz+EDofQf+4=;
 b=hdaXJ9UR+kU69+U0e3OhEuX9XhcBMJ80bN14hYe3QRCTvq9GQhu00e0MbjHFZFgO11m3HCfkEyH6GNeOdXhWnv2LgyHQXXt9Li6rZebhEkhkV36qkHhgaElpoac5OpV1QPyK4zuChcynSMceKAEw653sWGF3K+joDvwqRyiBDNv2ZzgGkLYoeFp21wAfuS9tEfMIa8Kuesf+aPZmhfbHEK/wFCi+/Fd6QRnPZ5wbf+poyVksJTtf6idydC8kMwaZncG6iNFO4Lgr+NfkmsEIeEcn4q+SG3FOyadZLd2ZMdzI3vxFAJjoMmbFsxkAUnh3kMAEvG9ncKuKO2dVv7/YFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UVYTdv20euefFjKileWXPWGMT15CFlsbzz+EDofQf+4=;
 b=CcNoYfjA2lBlh1Zf4uIascrsT5oWbvmmQ3FbBJvGWbV2ZgHavx/1fMgo8yvkdUEABIYOM6AF1cuxjbF/kIpoNU4npMT+rzT+LJEzgb5jZVjmMJmIOGx+C3LIRb5h+ZH/7XJZa7V6RRlpG/+4h/J8QYybqBldkTOd/u8Cl8J8C/jLyUs7D+jNKTIlbS9n6s5KT4JCdDx1BhVTHY4El+ef/KfmoZpCb2ZZCihaOdCA0gJ8hyd/J2Ssg/CqB4hv/hwL0doBOOkuzAQrS2ZKjWDZeeCVpAdrGEBukNuMSO+ZDKtD0CYgwUA7oGPFhy0fMXbuT4MnfUCrevqqheWFr8sfJg==
Received: from BY5PR12MB3763.namprd12.prod.outlook.com (2603:10b6:a03:1a8::24)
 by PH7PR12MB6884.namprd12.prod.outlook.com (2603:10b6:510:1ba::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 12 Apr
 2023 08:43:56 +0000
Received: from BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::34ff:4722:ca6d:3b2f]) by BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::34ff:4722:ca6d:3b2f%6]) with mapi id 15.20.6277.036; Wed, 12 Apr 2023
 08:43:56 +0000
From:   Ankit Agrawal <ankita@nvidia.com>
To:     David Hildenbrand <david@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "naoya.horiguchi@nec.com" <naoya.horiguchi@nec.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>
CC:     Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
        Vikram Sethi <vsethi@nvidia.com>,
        Andy Currid <acurrid@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Dan Williams <danw@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v3 0/6] Expose GPU memory as coherently CPU accessible
Thread-Topic: [PATCH v3 0/6] Expose GPU memory as coherently CPU accessible
Thread-Index: AQHZZ+i8u70mij1HjUyTq5ywHVPcyq8eMQgAgAkzb0w=
Date:   Wed, 12 Apr 2023 08:43:56 +0000
Message-ID: <BY5PR12MB3763086D7CD36B7B158FC426B09B9@BY5PR12MB3763.namprd12.prod.outlook.com>
References: <20230405180134.16932-1-ankita@nvidia.com>
 <46f68930-fdfc-db3d-5f28-521ff76e170a@redhat.com>
In-Reply-To: <46f68930-fdfc-db3d-5f28-521ff76e170a@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR12MB3763:EE_|PH7PR12MB6884:EE_
x-ms-office365-filtering-correlation-id: 74b9aac1-17cf-4a7b-3dd0-08db3b320d59
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kWoEBXJmUDKxPAakXqyUIkhADEdUkwRFZmNEL63I4s0AjHCtts7Q5rDc5sUFG+MZHx/55YAO3Yh46taO+X+Y4fe0z6V8muALOVNBq8+PPnMD+EZ1tpiJqS3jaoJcCkkmntqzczQUJMNK54dIqSRNHXjx6+6SFzld2/tPLWm3cVBVJs129bZDxGNk0uZSeyHYUhl+veqq8JZdEvvmQngQ3NtCVmlnME5XdYl0zbjN3+ndU30I46aLoz3ct0fzT4Z+4e02oXyEznhskTZQb+l79WTRY9JEVolItP8Mo+7glxb7nQ55UIWZDjznOiRUsEHQngn+wxI/J2P91Q1uakgtsZ80W0gmR7wgADUS5v2SB2XpAdSe/x2+VtiblrbqvZS9DlqCjPSD9kvNHc7u3ZcMhLxp8DYU0oWxg+IFqCQYbVpeH5Kspw4VvTYoNQWKZkZ0vSGXXicH1J+siMfV/SRbggDzwyaYPnaJ9WkHknn2GsAiBDo3NFWi2GvS9oEGRDfQNfJwKcygKDdw7RGRk1D+X5B2yeacWL5A8rAh+ZCRW0zmUJEk/cndiny5WheEK5TYlJLNjKfQL80Z3wyU7QtaCHbZ10Gz20KFVQaGP9D/4qWtcvaASR3JELkAWMaAPdfJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199021)(86362001)(54906003)(91956017)(71200400001)(2906002)(9686003)(316002)(8676002)(186003)(110136005)(83380400001)(6506007)(7696005)(26005)(122000001)(38100700002)(33656002)(64756008)(66946007)(5660300002)(66556008)(4744005)(4326008)(76116006)(38070700005)(55016003)(41300700001)(66476007)(478600001)(52536014)(8936002)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?lps+jXJOzorOMflZ07o/HkndT1nufKLY5LeOpQ6OwZWh8e7VK+YKelo1+g?=
 =?iso-8859-1?Q?EX6nkwUdVXs+Wn8KNdET6d1Bj87wqm60hp6ShyahLUupncm1HGtLHBTiWL?=
 =?iso-8859-1?Q?WAfDdSWnetcTfPmAG+Zvg9EJu1tlHjyqvomA6Yc2yMku/N4sxLOjb+Ego6?=
 =?iso-8859-1?Q?YmpgRKysOKPjasSZx8kHg3ryv6QVEYW+2pYJxEE2kt6PsL8dca+QZWTq1H?=
 =?iso-8859-1?Q?cBq8YX0ZR+H2E8/6Jd1rLtJb2RaXL7n0b6ORMlfguGvELDR6Gn8YbI6mg1?=
 =?iso-8859-1?Q?g5vNzy4sUOk5F6JY0SqbwhbnZFgy/sSN7GgTw9f5LTxQmTYvBs5TYwrzS6?=
 =?iso-8859-1?Q?zcb6nfUG+kUCe40FH4rX/d+wwXDiVC+S8tI76gtEA8Q5su1tfQogpsFWgj?=
 =?iso-8859-1?Q?A4QLM7Re0Xu+7TWl+UiIeQDNvrBDB46zFfedSv1XnZEukUyividJdetLaj?=
 =?iso-8859-1?Q?1JDolvAe3WvgM2iKIrgF3bWOxvdZDyyPcfKxceRwAetsWjUfKoi+8lAk1h?=
 =?iso-8859-1?Q?JyBUhZNpBCBFHgVnmbncgMdWmAUEblxoRpWuYj02P/lOr0ymr9p7b/AeZB?=
 =?iso-8859-1?Q?/VEApj7J21RqLndlKI9HdyV4wNDcFStkGQcte/nOsAtZq71+m94N4CG0yZ?=
 =?iso-8859-1?Q?ZEulmFEN3Z0yCE5sv7QJ9fXt2nCJmc99Ndktr1sJDoXSjbEVF2DtS15bdF?=
 =?iso-8859-1?Q?tpUvfeTLlnuNqlpzmuySDrrPAX36D4bel5EHJ/MW2z0AzhIa8qOEWxMh0w?=
 =?iso-8859-1?Q?eYdCYED/ee92PBCVNXb6qloWwprWy5WuPxxmXpz7YnCdjqJzNXEKcs993D?=
 =?iso-8859-1?Q?Bgk5BG/5ul7RBHH9WkIc5DrfokWHioetPK2xxrNv+XXY5EVng/A4NscmhJ?=
 =?iso-8859-1?Q?FbuMA56JjpGaiZ5bKevpseWgRzhh7/6lHgQm5FSQX3x6Lom01pGq28IHME?=
 =?iso-8859-1?Q?hpa5h1fdzDiMDTNAw8grgf+cTzm2jEK6rEBWf+H+dvEpBAO9ChZLooZ2zb?=
 =?iso-8859-1?Q?ROGB7uFBDQbH4Rc5CzfWsjDyeM27JHQCflD+AfNTAftk/L+MjOscNOWIMI?=
 =?iso-8859-1?Q?ICWhstVJio8urDjIXbZVWzF/1ZTZGVdBxvRqfDNlqX8oFfG/RNa3xLRr/8?=
 =?iso-8859-1?Q?U/ZOnqt8hOmmLZ4kUwNeF3VJ+PLoBpW7t8vlhVDIhnHV3TtViVs0zWko2m?=
 =?iso-8859-1?Q?9R2RaAAJ62DwfaOLJx1qZKiYVuVQhGmeX1LmCWgjo3YpqSykPw9ekf3hu5?=
 =?iso-8859-1?Q?ZhKLS0pjIxuRKu1Z4RoSedoPe5uwI9oKhvKjdNc6FNdtb9qfeCRa5gxNc+?=
 =?iso-8859-1?Q?Y+w5iqCXqN1A/U96wO3ZYOra4oslBsNvuOiL1EY6h6/pP14aidnfhFQhrS?=
 =?iso-8859-1?Q?zpuxF69jrepjCukiXW+WOUFyfhSeq+x15QSneudCSC1XZAuaRTvUuDxr5f?=
 =?iso-8859-1?Q?UeoI9r02mvBhS8exojUaoyL0pv5hFGsNnbcnlnIHdyn2tHeu3/txWxfU6P?=
 =?iso-8859-1?Q?FUrl43mp1JDSS0VYeohOxSFYrIsYRljuHUndN92gqDHM9hrZS7cSu0Fs0y?=
 =?iso-8859-1?Q?fsZOoXdSXM15P16OVEZMfLRWDyiv1g06Giwc1PBaH5T1i9Yj86gVAFmYDW?=
 =?iso-8859-1?Q?iJwq3fW0SI6U4=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74b9aac1-17cf-4a7b-3dd0-08db3b320d59
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2023 08:43:56.1396
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ki1fckmTruSbvZFjsw08FVRDXB82Ni2Ex5ObaBU/JzDFM/oIKq+Wf6q1gRj1HeoQA/zQYYzInDaRTSHdeEijNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6884
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks David, response inline.=0A=
=0A=
[...]=0A=
=0A=
> I briefly skimmed over the series, the patch subject prefixes are a bit=
=0A=
> misleading IMHO and could be improved:=0A=
=0A=
Understood. Will fix that in the next iteration.=0A=
=0A=
=0A=
>> Ankit Agrawal (6):=0A=
>>    kvm: determine memory type from VMA=0A=
=0A=
> this is arch64 specific kvm (kvm/aarch64: ?)=0A=
Right. I'll change the prefix to kvm/aarch64=0A=
=0A=
=0A=
>>>    vfio/nvgpu: expose GPU device memory as BAR1=0A=
>>    mm: handle poisoning of pfn without struct pages=0A=
>mm/memory-failure:=0A=
Will change the prefix.=0A=
=0A=
>>    mm: Add poison error check in fixup_user_fault() for mapped PFN=0A=
> That's both MM and core-KVM, maybe worth splitting up.=0A=
Ack, will do.=0A=
=0A=
>>    mm: Change ghes code to allow poison of non-struct PFN=0A=
> That's  drivers/acpi/apei code, not core-mm code.=0A=
Ack.=0A=
=0A=
>>    vfio/nvgpu: register device memory for poison handling=0A=
=0A=
Thanks,=0A=
Ankit Agrawal=
