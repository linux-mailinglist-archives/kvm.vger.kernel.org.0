Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3037C7B21FD
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 18:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbjI1QOi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 12:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbjI1QOh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 12:14:37 -0400
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014DBD6;
        Thu, 28 Sep 2023 09:14:32 -0700 (PDT)
Received: from pps.filterd (m0148664.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38SBt8I6021175;
        Thu, 28 Sep 2023 16:14:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps0720;
 bh=Z0f3lnzxOxjL0qn9sxqeOn4ghazcddhEnmDWmw2v71g=;
 b=ko0lU+pacQOSqw4Uga2cFqCioOyWWb7nEepzYoAwuv8DTaKEievEmIrDsBZJ69/Vkbth
 4QBHxy6xba67NniywhJMTwmWXrCdiUs/mcD8OjpMe/PAgPSCuOGt025wHrSuYrj4AKgr
 5QEdGxngaZ8oub9b9iQnqavFIrwG3WCPoWRl8FUcwj/TjB2ut4NxTAgRImtQPmb7FXBv
 2MfD/+e/9GljnMZqbVrrKSv0OPWFUPUqm9hlZkWfY9eGAJAUVN9bUpjNy/TspMj0Kwbz
 kDQ1uMWDuCVj5Eec4CIPwgVUk1lTlI6nz0h2HNk/I7ZymUAgj7DoavgZKUbGNNVNHZdU mA== 
Received: from p1lg14881.it.hpe.com ([16.230.97.202])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3td6buv0rc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Sep 2023 16:14:00 +0000
Received: from p1wg14925.americas.hpqcorp.net (unknown [10.119.18.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by p1lg14881.it.hpe.com (Postfix) with ESMTPS id 18948805E76;
        Thu, 28 Sep 2023 16:13:59 +0000 (UTC)
Received: from p1wg14928.americas.hpqcorp.net (10.119.18.116) by
 p1wg14925.americas.hpqcorp.net (10.119.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Thu, 28 Sep 2023 04:13:48 -1200
Received: from p1wg14925.americas.hpqcorp.net (10.119.18.114) by
 p1wg14928.americas.hpqcorp.net (10.119.18.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Thu, 28 Sep 2023 04:13:47 -1200
Received: from P1WG14918.americas.hpqcorp.net (16.230.19.121) by
 p1wg14925.americas.hpqcorp.net (10.119.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42
 via Frontend Transport; Thu, 28 Sep 2023 04:13:47 -1200
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (192.58.206.35)
 by edge.it.hpe.com (16.230.19.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Thu, 28 Sep 2023 16:13:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CvAu5rlsJYK5E2fe2vQaTYVFn+amjphuapB4RHci51pNhOavGyfV5ytKwnASXFTJvdRiFWAtGDk11jP2bNf+qJfgCUPIZ/QS9O8iUtPZcX9VliLzR8dfRbxbfsk44LndIygDK/be1FeLIj4SpHGj/998X7fkmbCb73gxToPO/+9kFbjKVEnZ41KheBOZTDAR22GChC3kQe3sW0QqH7Fn/9u47ZOUGfkD1FxoErQcNZ+u540LUeziPoKjTF51ww87wJ8nanXKvorh48bAYpCiHJMsEfuPe9zhg9TBwlpOa75gprOTj+Oogj4MwMPpVz08Yhde9fSHKZz2RisxY7zS0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=89fqALWf/zuuMNumRE9wwH2BQMeDCUQMwz23VmISzK8=;
 b=dLs/TlaiwUnK5mXXj+H97z7vY7DpbawF6jO16INUJMm9ATVFCLv1hW0FRzzeAai8DXFcXBgpYG4oexdfDqwc2BW5A+VYfz/p009HZqekTW9GYp8Cs9YUA4UQsg82LGn6T35LTiXnvPzKE7gq1LjfcBFUJGXk+1tBe0dztBJqk+D8AlQo4Da1p5LPp+wLbQuvpYqalL+CPkHdyGKB8xO4VzNxqLwjEy1J7I9TQgRNNgLKTa2jjeRhENXksPxcesKQ3EaPArM4dDW9ZANdB6GKP3Y4QrWguWWYy7Hz7l/OzJ6T8cO+81AHiUEuuj6p1N+dTcuv7e2FVwUi+lvZf5zwbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW5PR84MB1713.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c0::18)
 by SJ0PR84MB3288.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:a03:435::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.22; Thu, 28 Sep
 2023 16:13:45 +0000
Received: from MW5PR84MB1713.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d03c:ba74:6f54:6091]) by MW5PR84MB1713.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d03c:ba74:6f54:6091%5]) with mapi id 15.20.6813.017; Thu, 28 Sep 2023
 16:13:45 +0000
From:   "Meyer, Kyle" <kyle.meyer@hpe.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Anderson, Russ" <russ.anderson@hpe.com>,
        "Sivanich, Dimitri" <dimitri.sivanich@hpe.com>,
        "Wahl, Steve" <steve.wahl@hpe.com>
Subject: Re: [PATCH v3] KVM: x86: Add CONFIG_KVM_MAX_NR_VCPUS
Thread-Topic: [PATCH v3] KVM: x86: Add CONFIG_KVM_MAX_NR_VCPUS
Thread-Index: AQHZ1tZc1nmOBFd5kEqRHDYSEipSi7AvdwOAgAEoIaY=
Date:   Thu, 28 Sep 2023 16:13:45 +0000
Message-ID: <MW5PR84MB17137745A3DD273FA2AB25679BC1A@MW5PR84MB1713.NAMPRD84.PROD.OUTLOOK.COM>
References: <20230824215244.3897419-1-kyle.meyer@hpe.com>
 <ZRStOxiGwvDwGlNq@google.com>
In-Reply-To: <ZRStOxiGwvDwGlNq@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR84MB1713:EE_|SJ0PR84MB3288:EE_
x-ms-office365-filtering-correlation-id: 11938b2a-d45b-4230-9911-08dbc03de400
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: svH911X4wL213k7rqV33grovV22FMy3lAbjzA+3zqvdK0hyrPHZGovWIw/FLvzX/IjGOfkqIFxDDCdgZTPNG61a905auqNeyHtImrZb3iSvSMpBrPFNGygy4CXMZ0kohTluF4I4XORcnKeO379O3i1lwl9Gy1SULndeBN001mfTmPUAacnxExshsfIWOGc+7skUGVQo34EZSJmXX+fe+4R4h6PA8ea9LiK2NV4I47tM3Z2J5iicaLMH/RQ0r4C2OL4uo2jvRi4GxNtN0ciAIjSYgGC8wQiO2d+OfubxDdfJ6lXrGlHwatbyXsAbzbyHrPl1QKhXcodutG5+KtqVYtMibAHOyIhym50m4AVaAO1cvjJbueN7S4zXDFaFkQnWAlVM+N+6YHQDx6PjLfDqeCZiFuXIO8uTqgvXMz0iPUOOzCsAQj6njIONmJyERFFyse1q7TGez+Xp4MbHk7XZB0aHG/1IrEuOvuUleogA3VHva3rDuCatU/2VfOcn08IMxqwalZCTbYcB24LxttQ+EfRjHjqxtiZQmG9n926xIgJ4pzt4txoixaexrsYGsuaRO7i05eIG+3dhtWJqzK+G276gGA4PBns67M+bldZ1/gmc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR84MB1713.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(136003)(376002)(346002)(39860400002)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(9686003)(6506007)(7696005)(71200400001)(83380400001)(122000001)(82960400001)(38100700002)(86362001)(33656002)(38070700005)(55016003)(26005)(2906002)(41300700001)(7416002)(8676002)(8936002)(91956017)(4326008)(6916009)(316002)(66476007)(66556008)(66446008)(64756008)(54906003)(66946007)(76116006)(478600001)(966005)(5660300002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?gPSZZ9nEHxUUqbmtUsV6b0tlx6vrgVqypMOnb0AHGL8MwgnVKDAa5qTDT4?=
 =?iso-8859-1?Q?cGUPYgtjIuyIB2TIjARHWFypMhjSWZK7DMwB1NYiGL5J6noetM3If5vnaR?=
 =?iso-8859-1?Q?oaQ9ksXlH9yerQPEmpsy0x+Vpt+akihtxKYOQcw2TgVr5aXVDbJ2QUwulE?=
 =?iso-8859-1?Q?AXEpXBmypAtT7lFy4U0HfzwGE5/fWplbaTrZaJm7N5TuHByKwlD/abzoEJ?=
 =?iso-8859-1?Q?zytjqfUFs7sb5vh6BBcPpdvMB0UqAjUEC79rFCg0heq7RkJj5Hk8frIGXZ?=
 =?iso-8859-1?Q?84NPdwt0qRgZVA47A76XWEyxwICcO+KDWOuX+PzIpZbLcv55dqlh6kzyEu?=
 =?iso-8859-1?Q?DPyopfdjRPXg3MgX4aXSAUf/E/SpxKdvkHJKx6eH8LnYcJCIMNxfoSQqsa?=
 =?iso-8859-1?Q?wISfc+YGCwWGGKNSG5Pop3Pp80Nd+0FqwiiNllGXJ4i/iv+zaxsV9I5hr0?=
 =?iso-8859-1?Q?ZBK8kvTPPiZEinFzoAC4ax4f4vdcfi6o78hyMWsJA9njKrbcJp4lgC3G1H?=
 =?iso-8859-1?Q?LJ13+5pm19ZNN/f7chZoIvbyYR07PN7MZmSzvpnsrTx9C7QdNSfVLuZ7RR?=
 =?iso-8859-1?Q?yWUgYxoTeGG+JcZtjlvQMbCgT+SuU9osrckx8BtSTrJr+wADowExhHB4Ie?=
 =?iso-8859-1?Q?AZ2dj+JU4FOX5QYK24Cg5v9QyG3InMN/iGWucmwdtQEdCKAT72dhenm2Hk?=
 =?iso-8859-1?Q?dR5J+29CdpzHYbcq96jPC1E5x0Sp7HaMhzcpI4Cmpzqe67hsAF7xaYjAUQ?=
 =?iso-8859-1?Q?XHRcJjUHO+gVFAPvcARSqNPgzz1GrJhx8+rNNx9tFOZouzREHwHAe3FvSH?=
 =?iso-8859-1?Q?hbnfqIgkw3UzYMNF0YzUL7RZZ++AT2wpZSRroL3K9fW8jz/ogtKgKRtsWP?=
 =?iso-8859-1?Q?7qghpFgybOftADv6kn1i7fg79X0EXrNCoIiuThyN5DqZgJmmhaPAijJuod?=
 =?iso-8859-1?Q?1lu/fX8NkkKqQydObaIi+ECyFbTYNBb5+Qod8LyT3W5yM2syCB67bLmUYQ?=
 =?iso-8859-1?Q?57xLf6+MMclwRjOm8DsltLoPcS8YF8DxIrH1i1a2EyAM/osDYdxhRzFlUI?=
 =?iso-8859-1?Q?RP34jhsKBcQUCw+UsclqT3rqwQeDqarspIxFoPGIqsIn4O+iEDJdzqcS6p?=
 =?iso-8859-1?Q?QqJSGqDMhif4MEJ0wdeK+vvCv+H2kGIBbquq27b3fE6bdo2Az6G7QMBstc?=
 =?iso-8859-1?Q?PIBSPsVE4wnl3Orf8mg1hhbu4MIlbrib099Ca9rPEs/oFbFS1WSD/TxqQ/?=
 =?iso-8859-1?Q?9egj53bRd/ElAEqsjlWSnkXdwLD9qU0+WvbjPd0LrDpxOY+A6pqGKTWnCU?=
 =?iso-8859-1?Q?sCtRvMFTspVwo7WVIRR0DIVdo1skO7XiqiEfmZWyuO1hVP1rg/Y64Gka2m?=
 =?iso-8859-1?Q?DD8pZuVpYTDK3psU4ejVvB0Msji2284UnIL1mMFgDpmdOc7HxHQrukUCBX?=
 =?iso-8859-1?Q?hgzEMTz/+bivhlTsKuVqvng5wyie0Rmlh201MlrYpRRWFLndMfNR2cP+A4?=
 =?iso-8859-1?Q?E+yLuS9uZdQwPRdHUsgjCvprbx1M5cYZ1inAYepUwtQd16lOv19q2XuUwg?=
 =?iso-8859-1?Q?3zp1K1AAutLYyFzwIqd4m+M0keHNBgpC9g4znN4brFnuxFK83FHvnmnydE?=
 =?iso-8859-1?Q?YKtMoJSSiZ1jQ=3D?=
Content-Type: text/plain; charset="iso-8859-1"
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR84MB1713.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 11938b2a-d45b-4230-9911-08dbc03de400
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2023 16:13:45.3408
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cYzIEbgtnt9p54v/W5x3Wmwbwv4zhiJE4x3/YJ2GJ53bQv9veqaLXadmADWDAsrOk4vA5yBRZlWcXp6SRqKMgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR84MB3288
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: vlLXDagHYoO8GsB7WYJT7CwM9X85zWM_
X-Proofpoint-GUID: vlLXDagHYoO8GsB7WYJT7CwM9X85zWM_
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-28_15,2023-09-28_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1011 phishscore=0 bulkscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2309280141
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > Add a Kconfig entry to set the maximum number of vCPUs per KVM guest and
> > set the default value to 4096 when MAXSMP is enabled.
>
> I'd like to capture why the max is set to 4096, both the justification an=
d why
> we don't want to go further at this point.
>
> If you've no objection, I'll massage the changelog to this when applying:
>
>   Add a Kconfig entry to set the maximum number of vCPUs per KVM guest and
>   set the default value to 4096 when MAXSMP is enabled, as there are use
>   cases that want to create more than the currently allow 1024 vCPUs and
>   are more than happy to eat the memory overhead.
>
>   The Hyper-V TLFS doesn't allow more than 64 sparse banks, i.e. allows a
>   maximum of 4096 virtual CPUs. Cap KVM's maximum number of virtual CPUs
>   to 4096 to avoid exceeding Hyper-V's limit as KVM support for Hyper-V is
>   unconditional, and alternatives like dynamically disabling Hyper-V
>   enlightenments that rely on sparse banks would require non-trivial code
>   changes.
>
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
> > ---
> > v2 -> v3: Default KVM_MAX_VCPUS to 1024 when CONFIG_KVM_MAX_NR_VCPUS is=
 not
> > defined. This prevents build failures in arch/x86/events/intel/core.c a=
nd
> > drivers/vfio/vfio_main.c when KVM is disabled.
> >=20
> >  arch/x86/include/asm/kvm_host.h |  4 ++++
> >  arch/x86/kvm/Kconfig            | 11 +++++++++++
> >  2 files changed, 15 insertions(+)
> >=20
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index 3bc146dfd38d..cd27e0a00765 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -39,7 +39,11 @@
> >=20=20
> >  #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
> >
>
> And another thing I'll add if you don't object is a comment to explain th=
at this
> is purely to play nice with CONFIG_KVM=3Dn.  And FWIW, I hope to make thi=
s go away
> entirely: https://lore.kernel.org/all/20230916003118.2540661-27-seanjc@go=
ogle.com
>
> /*
>  * CONFIG_KVM_MAX_NR_VCPUS is defined iff CONFIG_KVM!=3Dn, provide a dumm=
y max if
>  * KVM is disabled (arbitrarily use default from CONFIG_KVM_MAX_NR_VCPUS).
>  */=20
>
> > +#ifdef CONFIG_KVM_MAX_NR_VCPUS
> > +#define KVM_MAX_VCPUS CONFIG_KVM_MAX_NR_VCPUS
> > +#else
> >  #define KVM_MAX_VCPUS 1024
> > +#endif
> >=20=20
> >  /*
> >   * In x86, the VCPU ID corresponds to the APIC ID, and APIC IDs
> > diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> > index 89ca7f4c1464..e730e8255e22 100644
> > --- a/arch/x86/kvm/Kconfig
> > +++ b/arch/x86/kvm/Kconfig
> > @@ -141,4 +141,15 @@ config KVM_XEN
> >  config KVM_EXTERNAL_WRITE_TRACKING
> >  	bool
> >=20=20
> > +config KVM_MAX_NR_VCPUS
> > +	int "Maximum number of vCPUs per KVM guest"
> > +	depends on KVM
> > +	range 1024 4096
> > +	default 4096 if MAXSMP
> > +	default 1024
> > +	help
> > +	  Set the maximum number of vCPUs per KVM guest. Larger values will i=
ncrease
> > +	  the memory footprint of each KVM guest, regardless of how many vCPU=
s are
> > +	  configured.
>
> Last nit, I think the last linke should be like so:
>
>        the memory footprint of each KVM guest, regardless of how many vCP=
Us are
>        created for a given VM.
>
> No need for a v4 unless you object to any of the above, I'm happt to fixu=
p when
> applying.

LGTM. I have no objections to any of those changes. Thank you very much.=
