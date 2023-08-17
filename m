Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D2077FEF8
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 22:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354852AbjHQUY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 16:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354849AbjHQUYS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 16:24:18 -0400
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1798359C;
        Thu, 17 Aug 2023 13:24:16 -0700 (PDT)
Received: from pps.filterd (m0134425.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37HFdHEA015259;
        Thu, 17 Aug 2023 20:23:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps0720;
 bh=Ttf/GkbwoBCqDAUzSd5KCh4AR1GTgm2hNB8aIlAWvj4=;
 b=KZvtwGbu7WzGEcvdQ7fFIfmoq3G8LMdJWrtQZw3rfUVDTtHzTgWj0RNxNLAVhgH7PCne
 uKMfM5PMjkaH1mbIORbMByTBpI38HRCDf97zW+0du3BMVI3u7QJj9cNJhahoUzh6TnwB
 0zs54s9m7I9u+QsB0lnnZRmY4YEr4kDtGKr9f5gC0nJDVUD6+VUb/Gzt/ng5j/omBjyZ
 CzTweR4Rh2XfT29nwQFqNuVSyldbTHOgRYh+tpJ9YRIqqCnzXHQVYYQpqI8/VsJrpg2o
 3Yp3QxT8psSrpqv3toBYks/hCNxcIWnnPGOAWeQ0j9oU2qNQz1IMUbpUme/93Hj9oqn4 kw== 
Received: from p1lg14880.it.hpe.com ([16.230.97.201])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3shpcntnha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Aug 2023 20:23:44 +0000
Received: from p1wg14924.americas.hpqcorp.net (unknown [10.119.18.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by p1lg14880.it.hpe.com (Postfix) with ESMTPS id 1C350801729;
        Thu, 17 Aug 2023 20:23:42 +0000 (UTC)
Received: from p1wg14928.americas.hpqcorp.net (10.119.18.116) by
 p1wg14924.americas.hpqcorp.net (10.119.18.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Thu, 17 Aug 2023 08:23:18 -1200
Received: from p1wg14928.americas.hpqcorp.net (10.119.18.116) by
 p1wg14928.americas.hpqcorp.net (10.119.18.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Thu, 17 Aug 2023 08:23:18 -1200
Received: from p1wg14920.americas.hpqcorp.net (16.230.19.123) by
 p1wg14928.americas.hpqcorp.net (10.119.18.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42
 via Frontend Transport; Thu, 17 Aug 2023 08:23:18 -1200
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (192.58.206.35)
 by edge.it.hpe.com (16.230.19.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Thu, 17 Aug 2023 08:23:17 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m96aExQ7jwWKhY6onbUcOpXNL62d0jx/FtUeqtXCj4HrAutg9EunTq97U2tSTD4LbaUjN06pTvAwt99XgLn6MpH3xl6EbGPd86vXULBNJIE0r1fuX2aK/poH8zdkHhhdgg6K/lbm1u4YlPKVXidGUA+A5AXytwuOlVT5dmBrpAuI1VXxHfyeu1+nwAVwqgK9EVzEq1jp71xHZfirgCOSl3zpHxylYUHqHeRlgk1dVn/GMbXYx1cJpFSSh/O8kDUyh1QoM/SvmPHlNKc6y1Np/AwoqgkV19UFo2gRHifIBMmL2vittFNc62oPBYssg2aQrX5/mjn0Oj1mqXPxoH4QWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IUGPZLr+CgaOh6SCHG1DnLW51efIOiI0PQBMGWxDPiw=;
 b=NxinPxEmWOlH51e8aHCj8xfJp90OeoOVz4Ys3XBdCjC6ifmUmpld3GRFPv5FxcpOFkskf6FwLFBSvZm5K6SO6xt2uJReopjiSZfwT/Zj1cbh/iuonFaf26OQsvlhnlm3Ej9CWu1n+q2q/0X8gNQt/fVzHlGPkbTfpPO2pf4hKDoJM8JqEx/iutiYXTCa7upiVfyBUdvIeGcQZgQ+hMnm90ySQ+Jig0E5rR9V+AJOYT/igha6AOBUBQRvcgJUjwyIyrHel/J1LWoM5ck5xF0mN5S6WanMqILKJkygH7amAXwSkWugiiLind6UJS11cZsC+ulZ4h6nuB3tdS4+jtwaHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW5PR84MB1713.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c0::18)
 by MW5PR84MB1820.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.31; Thu, 17 Aug
 2023 20:23:16 +0000
Received: from MW5PR84MB1713.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::cf2c:5241:904b:872f]) by MW5PR84MB1713.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::cf2c:5241:904b:872f%7]) with mapi id 15.20.6678.029; Thu, 17 Aug 2023
 20:23:16 +0000
From:   "Meyer, Kyle" <kyle.meyer@hpe.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hasen@linux.intel.com" <dave.hasen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Anderson, Russ" <russ.anderson@hpe.com>,
        "Sivanich, Dimitri" <dimitri.sivanich@hpe.com>,
        "Wahl, Steve" <steve.wahl@hpe.com>
Subject: Re: [PATCH] KVM: x86: Increase KVM_MAX_VCPUS to 4096
Thread-Topic: [PATCH] KVM: x86: Increase KVM_MAX_VCPUS to 4096
Thread-Index: AQHZz46rfYQUAzw04Ue89+IwjbMqqq/rl+SAgANZoAI=
Date:   Thu, 17 Aug 2023 20:23:16 +0000
Message-ID: <MW5PR84MB17135D3B5BC50FCFD3D9DEEE9B1AA@MW5PR84MB1713.NAMPRD84.PROD.OUTLOOK.COM>
References: <20230815153537.113861-1-kyle.meyer@hpe.com>
 <ZNuxtU7kxnv1L88H@google.com>
In-Reply-To: <ZNuxtU7kxnv1L88H@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR84MB1713:EE_|MW5PR84MB1820:EE_
x-ms-office365-filtering-correlation-id: 9274bdec-45da-46dd-bcee-08db9f5fc9f4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xCjVK9iQBKmPMVoYkauMk1KxPzaFXn6Rg+1Yky9m8T0p8DKVot3H+YG2oO2EZzzlJ0dlCZf/R+gXaxKBfPi8RPL7LgA0q/6BeERPZvfomWMnL7l6hQqwNNE0slCdhm6/Eyk10hDW3lgtVSjFZV7EnMXpu64dJgetyBtlTshlxEdSCGQQhv/4nveDdyyn9MLDBNHKrtP7fb21NRBUhP7RitVTQnmbJRs3vLOlVs5Ypsgm3MwTyoHD+GFPv/yNOvF59lWCM3YNrUxj+obZv4XW8xVjpsLH05ctjs+8Ohjn9PXTkgSsRMpCg2XBgkwo98e3kYrjWKJBkvCnqyneMdan3xvyYB8r4yYAIZzcEcCncprfEp+nKXkYBs2i1qOAFPoOrYKhXRqo36JWMd3MxvQwkWdmsYuAJV/FyE64/9rZzuGjWM7BkvLJVMEEyZY0vD3z79XugGZNqVmqcodFLho91RK6rwwkK5N6yxvmtXDLLL5XeYo4LfpjLIWljhGV9Vxbgu2Hq049ikkQpIktdggxR3GWm/oqCIFNqtF52hVZZ9J932Bt2L5yr3TrStgPcNY72D2hBieQ8mi+ajsWYvu4HbaqJ6s2JGVyYqsDfuqK228=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR84MB1713.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(346002)(366004)(136003)(39860400002)(186009)(451199024)(1800799009)(33656002)(86362001)(55016003)(5660300002)(8676002)(4326008)(8936002)(2906002)(52536014)(41300700001)(26005)(7696005)(71200400001)(6506007)(83380400001)(9686003)(966005)(478600001)(76116006)(7416002)(122000001)(82960400001)(66446008)(38100700002)(6916009)(91956017)(316002)(64756008)(54906003)(38070700005)(66556008)(66476007)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?j12ooKSRUvjrRZT4NFrHWxdC03i8KY9Wznj19gsqxMYtXnXhMv3WbPCoh4?=
 =?iso-8859-1?Q?6N1UezYtSX2czP661u0t/dGpyMzYAoMNix3WzRbdVj6IJyyF0wKWchjyTz?=
 =?iso-8859-1?Q?yVirKnNjfDR3MqNsSYFHWJiyR4yKYWxPwsz792HDM2gHNS7IjtvDM1gkyD?=
 =?iso-8859-1?Q?2Iv2ME9FYjrYW4K3bNJ+jQCqzEXfqC4sn5ML9I1dubfE9BtzdGY9nswR2G?=
 =?iso-8859-1?Q?0RrFhbgHukwOEMh9NKP/dG5MzfPl7YxuzqA9h4l0AXuYPuFvRu+3hgg/QO?=
 =?iso-8859-1?Q?AypTV7VGX3fzqXB1NmBMb5LYvj3mJAkNgBxpnUEmD+QARF0EuKNO0K9uI1?=
 =?iso-8859-1?Q?CX05BHpd9Ydyd87CDb5ingU+S+HaFLvWLDN22UqENAzSuYKyKyZR84/o8V?=
 =?iso-8859-1?Q?7IXkeDGNyZBLjPbmCCSvgT7Hy+NYQQbWOJiYQSG03jC+KgH4vYEM09LYeu?=
 =?iso-8859-1?Q?48LKXJU8BzyQ4Q69Q8Hw+TWnE1IGa5UbEc8HOL+1w5ZlQY6RU/YNYgW9J9?=
 =?iso-8859-1?Q?7Vchb799APo3EEJ83t7qoGheTCdZjeYWhOUVheb26cJFt08mRh8EVRjP0N?=
 =?iso-8859-1?Q?tBk2Acgvel44BSPeK5GWEHBq+BCZf9Un4molcQUm4gRnliD3AneYrRpof+?=
 =?iso-8859-1?Q?kSjjmoRK53SF8Us6w+YHcmToqC/ihzsw9WKEhaajhObWE3p0Ni1TlQ6OEm?=
 =?iso-8859-1?Q?9+6hxsmAObXeEL/NfwdAxWu0bh94C6LyF/ozrVzANrzEGii8ufJVenvUrl?=
 =?iso-8859-1?Q?oFL1CYUQCgyFJ9BwMa4mZ9AvMq2iIWHb/6ENCD4Ywt85MVRmkt1sl7J3A4?=
 =?iso-8859-1?Q?YfIOcwCtb/SaMEULSM0g1rzhEKX4I5VRhHtc3/Vq8bDCsbaheKLg/SF3MU?=
 =?iso-8859-1?Q?jeGo7I1DR/b/+Od8q0ZgszaU7XV2AhyNvo30Wr/okWuDEuet31dyMqU07D?=
 =?iso-8859-1?Q?I3PYO9W/Q47ZD34neFlC1ppBQ67qOY8zxASYS8ttuE2qKXoJ8go1wwRfy7?=
 =?iso-8859-1?Q?mcChIcwSQ5jABGhXxmLB7y6LhZWo2moyr5BWYqmaOgvKsRks7CurPSrXxr?=
 =?iso-8859-1?Q?09WKu44KIjTOFTOUhNklEIAnd8X6090WbK9bK5yhQn6tL2ljaqrRDNT+mS?=
 =?iso-8859-1?Q?Swt/9ODJFeVHmJQ6WOqhFrPUn9Hx4opWJhD58xLq3+JI6o7Wu4B3dt8nCK?=
 =?iso-8859-1?Q?XlcPHmMoRjLV+Y19dDTevb9mj7pLN9b2+NckI6GNuyhA0x8GZeitK2V0rB?=
 =?iso-8859-1?Q?WU5WPZjJVDYWtUxgRDq9bNIYQOTXmOyLOPoMMfgljj1D1lXZgNFPMab9XS?=
 =?iso-8859-1?Q?rnVkv2cftnFFXQShnc56I3m6Gi6QQ7AFC6fKo30P67qYghXly43CUdM0sN?=
 =?iso-8859-1?Q?753vPNUfWoehnC4L62Kh7h4QcPCofdIVq7fVoxEfv5+Cdlx53CeOpdG0rv?=
 =?iso-8859-1?Q?vCl/+Cv/6karsOYB3JbjSZmWTDwaaHSNXk2NCnVbanJPPS/rBicRDGb8W4?=
 =?iso-8859-1?Q?szE6hi1/MC9bzq4zkfVLPfMg7Ike/FY7Qsoah2rP9O1TZ4uF3bCz3nL4IC?=
 =?iso-8859-1?Q?PDg7sZKX4gqTIxjd5ohi51j34EgGuJZBAv5LVN1L35X6HgJSbzaPzw7pai?=
 =?iso-8859-1?Q?ucHkLT8K/Q5bo=3D?=
Content-Type: text/plain; charset="iso-8859-1"
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR84MB1713.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 9274bdec-45da-46dd-bcee-08db9f5fc9f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2023 20:23:16.1538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UZZ1uG2VlI6SW4KQTxtrsccO2+dVGkKzDtUNvf9Hc6fXcxax9r/P/4G46jDG4r0HX5aJiLwUiNEtpKzdhL8xOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR84MB1820
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: do5CVNRJrbtejcsh4LTZk_3p80L6JqeN
X-Proofpoint-ORIG-GUID: do5CVNRJrbtejcsh4LTZk_3p80L6JqeN
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-17_16,2023-08-17_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 clxscore=1015 spamscore=0 phishscore=0 mlxlogscore=901 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308170184
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > 4096 is the current maximum value because of the Hyper-V TLFS. See
> > BUILD_BUG_ON in arch/x86/kvm/hyperv.c, commit 79661c3, and Vitaly's
> > comment on https://lore.kernel.org/all/87r136shcc.fsf@redhat.com.
>
> Mostly out of curiosity, do you care about Hyper-V support?   If not, at =
some
> point it'd probably be worth exploring a CONFIG_KVM_HYPERV option to allow
> disabling KVM's Hyper-V support at compile time so that we're not bound b=
y the
> restrictions of the TLFS.

Yes, I care about Hyper-V support. I would like this limitation to be addre=
ssed
in the future.

> Rather than tightly couple this to MAXSMP, what if we add a Kconfig?  I k=
now of
> at least one scenario, SVM's AVIC/x2AVIC, where it would be desirable to =
configure
> KVM to a much smaller maximum.  The biggest downside I can think of is th=
at KVM
> selftests would need to be updated (they assume the max is >=3D512), and =
some of the
> tests might be completely invalid if KVM_MAX_VCPUS is too low (<256?).

That sounds good to me. I would prefer to set the range from 1024 to 4096 in
this patch.=
