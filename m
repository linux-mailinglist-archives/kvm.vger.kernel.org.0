Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFA44B907
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 14:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731422AbfFSMrM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 08:47:12 -0400
Received: from mail-eopbgr60138.outbound.protection.outlook.com ([40.107.6.138]:49664
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727244AbfFSMrM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 08:47:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=k2kG0wZZywwaOzw0DCyUFgchRGQMxOUPNB2uuwXY4KQMLvoZ0EenmCRX8yUnbqZ/ksMpQ4NbRF06NA44s3a5N5K0q9IvXnsKtDOib79ayveuA/YlCYeS8HNpUZTuT9Wur8jl1aEX4GwlcdUosqp6QqA3xSWa37X97TYM/I+Klnc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=foixROCi46XEuN/qSRZxW5IpvZ/dE5Cx+JvK2H5kqAc=;
 b=eplxXYbYqivX2rLSA7GYMsQVmjADcrimvzYQGyUl38aD8DGbAvO2/PXFfOOgrIO9ENnnO3Cuom+ijGkWluhPukUjO2/AJRBKvnfH1Lr6XMDjXmTZ9IqdzOFl4CeeAmqQAUZoA1a5UDb3DR7MAM/jiEZk+6BeZruxoRvRhO8I9y8=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=foixROCi46XEuN/qSRZxW5IpvZ/dE5Cx+JvK2H5kqAc=;
 b=HTPDYB2eWU9apwVjMIbmZ08cBwsctGOj5+cWS/q9ABB7laaEpzEg3zt543fSdIICxmvUD5+1qvuZyItgpIV6w2ExAHDPYfyeT+5K+uNm4FArLZxPNurw+2ZZTjmJmhJSQTy0hWw8mcYVPAFTmuq8xn4k1FXx3sYRLb9iNbRFrWs=
Received: from AM0PR83MB0307.EURPRD83.prod.outlook.com (52.135.158.26) by
 AM0PR83MB0290.EURPRD83.prod.outlook.com (52.135.158.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.1; Wed, 19 Jun 2019 12:47:07 +0000
Received: from AM0PR83MB0307.EURPRD83.prod.outlook.com
 ([fe80::d5bd:2140:9c7d:278]) by AM0PR83MB0307.EURPRD83.prod.outlook.com
 ([fe80::d5bd:2140:9c7d:278%7]) with mapi id 15.20.2008.007; Wed, 19 Jun 2019
 12:47:07 +0000
From:   Saar Amar <Saar.Amar@microsoft.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     =?iso-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>
Subject: RE: KVM: x86: Fix emulation of sysenter
Thread-Topic: KVM: x86: Fix emulation of sysenter
Thread-Index: AdUl2Gp2BwAKQ0wfSgGk5OKoaj0PbwAB2jSAAC9LWIA=
Date:   Wed, 19 Jun 2019 12:47:06 +0000
Message-ID: <AM0PR83MB0307821E5CFD654F2E5F7403F1E50@AM0PR83MB0307.EURPRD83.prod.outlook.com>
References: <AM0PR83MB0307F44E915135F79E291058F1EA0@AM0PR83MB0307.EURPRD83.prod.outlook.com>
 <53b1ac7e-0170-b966-d3f0-298e291e9bdd@redhat.com>
In-Reply-To: <53b1ac7e-0170-b966-d3f0-298e291e9bdd@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=saaramar@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-06-19T12:47:03.9271789Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f4e53d1c-bf31-4a2d-9bfa-0ecc95a8dc29;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Saar.Amar@microsoft.com; 
x-originating-ip: [2a01:110:8012:1012:e23c:171e:7399:8fe5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5f0baa15-9eb2-4b74-4887-08d6f4b43ccb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR83MB0290;
x-ms-traffictypediagnostic: AM0PR83MB0290:
x-o365-sonar-daas-pilot: True
x-microsoft-antispam-prvs: <AM0PR83MB0290ED3F1BB63348D64E2DD6F1E50@AM0PR83MB0290.EURPRD83.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0073BFEF03
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(376002)(366004)(346002)(396003)(13464003)(189003)(199004)(22452003)(81156014)(9686003)(110136005)(256004)(186003)(10090500001)(53936002)(102836004)(6116002)(4326008)(5024004)(86362001)(6506007)(68736007)(2501003)(6246003)(5660300002)(7696005)(53546011)(8990500004)(55016002)(25786009)(486006)(46003)(10290500003)(11346002)(476003)(446003)(76176011)(4744005)(73956011)(99286004)(52536014)(66946007)(71200400001)(71190400001)(76116006)(66476007)(66556008)(33656002)(64756008)(66446008)(478600001)(2906002)(316002)(305945005)(229853002)(14454004)(7736002)(74316002)(72206003)(8676002)(8936002)(6436002)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR83MB0290;H:AM0PR83MB0307.EURPRD83.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XowRZAhkfa2GyHADP1dI2cXm+5Wd9xSG6MFu/hTyU7ffXB2wGWMPjdO7nICwpwXF20M4i5o4auaYAo/DUnM9m2UGoJmi67EQzEptVMpg8QVUTJrRw/2vIRXFEJ3p9thx2DplEnxgyINF4ZbC1bbPIrdADSXlFpSu+4RX+xUGnp1Wor+vi6sFP3ToJnGgkCzFPuN2mvkahFiaB3skCO3J0DYt9fNGb13p4xf84hcn5n3YSwYodZ3fQlm+O2eifvr4a3+AmbUgYG2aK8holLCdPNqPEO6cR5VKibMmfmgBtUeWDycrsyoU3x28Re4xFwsprTgeSfrwYJyO6d7r1xRnaN/QJUg74zCFUT9CoWaQp2w/ONH14RuR0B61YdyPF+mKB1DL5xPo0qM9dajfoKD7AcdMXQKWX0IUX3AsERJlnXw=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f0baa15-9eb2-4b74-4887-08d6f4b43ccb
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2019 12:47:06.8510
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saaramar@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR83MB0290
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yeah I see there is not flow to en_sysenter which doesn't pass this logic. =
Thanks

-----Original Message-----
From: Paolo Bonzini <pbonzini@redhat.com>=20
Sent: Tuesday, June 18, 2019 5:12 PM
To: Saar Amar <Saar.Amar@microsoft.com>; kvm@vger.kernel.org
Cc: Radim Kr=E8m=E1=F8 <rkrcmar@redhat.com>
Subject: Re: KVM: x86: Fix emulation of sysenter

On 18/06/19 15:19, Saar Amar wrote:
> I found a bug in sysenter emulation. Patch attached both in plaintext=20
> and as patch file.

Do you have a testcase for this?  RF is cleared for all instructions here:

        if (ctxt->rep_prefix && (ctxt->d & String))
                ctxt->eflags |=3D X86_EFLAGS_RF;
        else
                ctxt->eflags &=3D ~X86_EFLAGS_RF;


just before em_sysenter is called.

Paolo
