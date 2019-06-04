Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D09434F19
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 19:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbfFDRhw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 13:37:52 -0400
Received: from mail-eopbgr30100.outbound.protection.outlook.com ([40.107.3.100]:64937
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726660AbfFDRhv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 13:37:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=yWA0Qpm6JWkPrbGONKM9OQnSG1VUBexQvsFzMuXADW57TFA7iL8TFw/NtkA+VM2mgIWs36zFyo91R37gtR4VSUzjAHZ91cwQUvTbMra2YpZgPQETmtOs/PByd4V4HqsztUYxI4kGl8TZPsmmHP1HBL8byq0cL8dUCbMofgrGtrk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0h3QTg6O50dMOCUvJSmxIUNBYPuJY49QGbBfMaCLBis=;
 b=QKiM+oW65AHnxvZQ4g5FYrTHFHKftP7NDRpOcqoB9gJeKXsqg+ELfp8Q6YJyj0SN0x1+RT6finP+BQ5Wam+dYIBcqy8Ee5wQiP2kVn4csZqkyzk/GABeUOdIzAFQwDo+LMpPCteaBbJgQGuD8YsW9TbZm9Ac72BfnIhyXiPS2X8=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0h3QTg6O50dMOCUvJSmxIUNBYPuJY49QGbBfMaCLBis=;
 b=BvIDo2Q/Q5pNcaJLuixvm/urp/CS0n283zV3FI9Zg6dpFhZKhaXFzfL1EJqtkzEwuuZKzYfMd0TglI0wlqFnzvNuOdAUmGIJKheq5AcNotdqvCtQW+3rqjxx2dtXqmbX+SrJD/XHcLmAls04AfNC0vJt9FG8LgQiEspAo0f3n0Y=
Received: from AM0PR83MB0307.EURPRD83.prod.outlook.com (52.135.158.26) by
 AM0PR83MB0290.EURPRD83.prod.outlook.com (52.135.158.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.2; Tue, 4 Jun 2019 17:37:48 +0000
Received: from AM0PR83MB0307.EURPRD83.prod.outlook.com
 ([fe80::34cf:76ca:6dd1:88f7]) by AM0PR83MB0307.EURPRD83.prod.outlook.com
 ([fe80::34cf:76ca:6dd1:88f7%5]) with mapi id 15.20.1987.003; Tue, 4 Jun 2019
 17:37:48 +0000
From:   Saar Amar <Saar.Amar@microsoft.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "rkrcmar@redhat.com" <rkrcmar@redhat.com>
Subject: RE: [PATCH] Fix apic dangling pointer in vcpu
Thread-Topic: [PATCH] Fix apic dangling pointer in vcpu
Thread-Index: AdUZJN49W6QDyt1hSjewybE8oMtziAB1R4YAAACM1WA=
Date:   Tue, 4 Jun 2019 17:37:48 +0000
Message-ID: <AM0PR83MB0307918B28E386A8BB792976F1150@AM0PR83MB0307.EURPRD83.prod.outlook.com>
References: <VI1PR83MB0317F837797D43F91B90149BF11B0@VI1PR83MB0317.EURPRD83.prod.outlook.com>
 <f4cf2f7b-1752-849d-4e99-1ce6b336c1b0@redhat.com>
In-Reply-To: <f4cf2f7b-1752-849d-4e99-1ce6b336c1b0@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=saaramar@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-06-04T17:37:44.3640021Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4a5eb840-6c81-4b67-9e58-abe6a1b9b84a;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Saar.Amar@microsoft.com; 
x-originating-ip: [141.226.13.39]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 31c08ae4-aeba-4380-9aeb-08d6e9135c9a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM0PR83MB0290;
x-ms-traffictypediagnostic: AM0PR83MB0290:
x-o365-sonar-daas-pilot: True
x-microsoft-antispam-prvs: <AM0PR83MB029075DC31C618FA704C61ECF1150@AM0PR83MB0290.EURPRD83.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0058ABBBC7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(136003)(396003)(346002)(376002)(13464003)(189003)(199004)(7696005)(316002)(66556008)(55016002)(66946007)(53546011)(76176011)(6506007)(5660300002)(74316002)(52536014)(110136005)(486006)(3846002)(68736007)(476003)(7736002)(446003)(11346002)(22452003)(4744005)(71200400001)(53936002)(86362001)(305945005)(25786009)(76116006)(66476007)(64756008)(73956011)(4326008)(26005)(186003)(71190400001)(6436002)(6246003)(102836004)(8990500004)(9686003)(8936002)(33656002)(10290500003)(14454004)(2501003)(6116002)(99286004)(478600001)(66066001)(81166006)(8676002)(81156014)(229853002)(66446008)(256004)(10090500001)(5024004)(2906002)(72206003);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR83MB0290;H:AM0PR83MB0307.EURPRD83.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RSP+PwZa9FeWTIW4OmD4Ddo8zBVMVOy0c9eNUrG2Y8gXfzZ56LTgxAytsHGYnLuAUiKx0xLAiPD3gNbqKC9Tz7tGKBP73iBftnW6byN9XCctc2A0ijg+8/G+3wiruH3+O/gPtcww/+MI8Z6b0mq0LFTSWJjSGBn9NnFPzfH+1q4Fmb6PB5CqgnloXM3AzgRzUTsb3HUpEp2Dumnxl48SOQcHN1QrkD3B+NcOLTx3zstlA59XkaB44/EQcj1B/ZqmICXw2k2tlMEfnsyLLZyVj+eqiviCoq3AVK7oPrmRsDrPpuWcezyGbeTlkxqnMuILpy05ro5+raJUuKBJNJ5GJhEJJoQH98pfY/RxJnodu7GCcdGC9XYvbYv+3p+f/iGfVSySa56eERZIujLon4MKCPNJbLWBiMARVY+1jfEqRGU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31c08ae4-aeba-4380-9aeb-08d6e9135c9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2019 17:37:48.4458
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

Signed-off-by: Saar Amar <Saar.Amar@microsoft.com>

Thanks a lot!
Saar

-----Original Message-----
From: Paolo Bonzini <pbonzini@redhat.com>=20
Sent: Tuesday, June 4, 2019 8:22 PM
To: Saar Amar <Saar.Amar@microsoft.com>; kvm@vger.kernel.org
Cc: rkrcmar@redhat.com
Subject: Re: [PATCH] Fix apic dangling pointer in vcpu

On 02/06/19 11:23, Saar Amar wrote:
> Hey guys, can you please help me getting this patch in?
>=20
> Attached both as file, and here is the plaintext. Thanks a lot!

Please reply to this email with your "Signed-off-by: Saar Amar <Saar.Amar@m=
icrosoft.com>" to indicate acceptance of the "Developer's Certificate of Ow=
nership", then I will include it. Thanks!

Paolo
