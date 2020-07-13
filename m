Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE4E21DF28
	for <lists+kvm@lfdr.de>; Mon, 13 Jul 2020 19:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbgGMRwN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 13:52:13 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:5843 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729681AbgGMRwL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 13:52:11 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f0c9eda0000>; Mon, 13 Jul 2020 10:50:18 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 13 Jul 2020 10:52:10 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 13 Jul 2020 10:52:10 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 13 Jul
 2020 17:52:09 +0000
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.58) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 13 Jul 2020 17:52:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DUPItVl+l1v98Ns9p6EtZHe9Y7J40/03OWqDyAzsBvkIF1+gOqRnCdg+AyVbApehG36AGfovySXYedUM2VHqtsStJ5JCQ/ZC4TyK49kMXq4wlfRlk+f41NCVJ2GbjsI0a8FusvOWn46CHp6rKKVbL8M2pVLDugzvQJChPsneFXP4/3UsjYTQVvhjyyBP0flV4QBdnMt9Y4c80wmUb+IHl8KWjGrYI7/f0TDchkaUzg4ZXCMawXOWPTx5Eld057POIIJXyMWl0tygxTFwq/K1FF3J0iglVyQ+MCPvMKMd2w9505lCAShAMuwEQk/n9TcUq17LZtwFDXNyN/BLd4LGyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oh/SMuVk+G/ry8XebILSmOOh3WNAlj+PiNrxxfIoniQ=;
 b=TquZSPDsJmgq1y9Z9WxYS8yssCqXimizr9oEzZUu+i53Zo0J8i5kVZT8CaQVmSMRaGe2BE2X2YrQuy87GZgd4/nesBq6ffrTetRyhekGIiAmndLASgt8u6wuYYS3YFG60wl24hdqu2kIgr2o340hTzhYCc/4L3xzXanjaFL9XML3CQml83UqDdknZ7FD+nKQROrrCrR8tw1IAvXElOQERQuZbj82gLqrm50FCPo0I/Tt1RsTJjhli5qGlnMyelx+9hG6BJfI3EZ4tBqz24S3CQsOh5vJ7ndRzTvf6DXgjSlF3GLVEApozPflVNF8xxdRGcmBR6aI5A/PJxp8Wpzg5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4164.namprd12.prod.outlook.com (2603:10b6:a03:207::13)
 by BY5PR12MB4002.namprd12.prod.outlook.com (2603:10b6:a03:1ad::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Mon, 13 Jul
 2020 17:52:08 +0000
Received: from BY5PR12MB4164.namprd12.prod.outlook.com
 ([fe80::ed4e:e409:c7d3:3187]) by BY5PR12MB4164.namprd12.prod.outlook.com
 ([fe80::ed4e:e409:c7d3:3187%7]) with mapi id 15.20.3174.025; Mon, 13 Jul 2020
 17:52:08 +0000
From:   Mark Wood-Patrick <mwoodpatrick@nvidia.com>
To:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "stefanha@gmail.com" <stefanha@gmail.com>
CC:     Mark Wood-Patrick <mwoodpatrick@nvidia.com>
Subject: Seeing a problem in multi hw thread runs where memory mapped pcie
 device register reads are returning incorrect values using QEMU 4.2 
Thread-Topic: Seeing a problem in multi hw thread runs where memory mapped
 pcie device register reads are returning incorrect values using QEMU 4.2 
Thread-Index: AdZZPLyvQ5ZqBCBXQFO4rjBJ3nzx2w==
Date:   Mon, 13 Jul 2020 17:52:08 +0000
Message-ID: <BY5PR12MB4164F24B3A00578D54FDB2D3A0600@BY5PR12MB4164.namprd12.prod.outlook.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [216.228.117.190]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 907484e7-0ddd-417f-4f75-08d82755769e
x-ms-traffictypediagnostic: BY5PR12MB4002:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB400211D4313D55E19446A90CA0600@BY5PR12MB4002.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bT/DVcQckGcS94l/rHAy2njda5n6yNA02H1w9OzUBLtToXp0K2x1AprvXyCwGZBcC8LdfMmN70q3GTWhsMDx6moJ+1jXA34QUs1Ei7/YmHKCYr74UXFtmsjOgKvX6DP62a3330pLhPjnngxtK1/yfysntNor4hsQcGZ83Q5PHx0Xx4nlUQvI5xRUsKyePiKzAqkLq9pQFRaUOxDO8lVwOWA71IC2LThLKM+FoQQIJBLnO3gQUHI59D38+lw5i/5E80UmNmr/YHEKCSdHSTd4/EAJ03ADPiTOzXT/D6U+IDiyeIMm8Lr9FO+pTF+4lxkBxdvg8gxAkqpGd1oIkGEMSw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4164.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(39860400002)(366004)(376002)(136003)(66946007)(66556008)(64756008)(2906002)(33656002)(316002)(110136005)(9686003)(107886003)(4326008)(55016002)(76116006)(52536014)(71200400001)(5660300002)(66476007)(66446008)(8676002)(4743002)(8936002)(86362001)(7696005)(186003)(6506007)(478600001)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: dgnQGjVoj4S3uqgb0lP5fIHkY8uBNrZGimoOc7vUL/lY4Vhkm+P0pdxUWoXLHksLZE0W4nt0axi3wgUiwlJ3oaur5Pp38ZtDx7TGVIe6wjEDtZhi3UjZ+OIkLRNguSdMgyAm/1dwyrbNnIcHGfQJ23QwNTjYeHd/gZvlCxXBWW+x+AzDJ1RxtCZOnJjG06SKfJMn4WB2awhg5kAJn133c1GJg+9ydYTFusdi7X5yTaXqCxTsq/5B7IwmU2D1Vc+2HQ2Nguw/gkD6eU5on9XIXS3lD87XcNstw3ZXExR+dRUzeNTqSRBa0FJphFCWSkJQknUNc+36+X7tE3vj9YRl3AO8lFRB1mCF9WfvVKIn7uGeoiQJ+PxZwldSNh+CVeM5tgc2JmoS1u9orZxWoPjB/RufUy5p4pVHqDUOgjELHliFcpIWMiBLjqBPJjIPows+fITl9f2D+s2P3cr8mdZWCqTIuOZ2zF53cnik/faRUH0JfAK1ZHfCKl4ssAuR8Pmf
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4164.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 907484e7-0ddd-417f-4f75-08d82755769e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2020 17:52:08.7042
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LWGF/ykIsIULRBY3Mt/WfM3uXznDjB274193PiL4uEmeqcFS4YvZogVexIHoyvH2Q2ZhkaxMY1eJUpDK3ajWSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4002
X-OriginatorOrg: Nvidia.com
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1594662618; bh=Oh/SMuVk+G/ry8XebILSmOOh3WNAlj+PiNrxxfIoniQ=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:Accept-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg:
         Content-Language:Content-Type:Content-Transfer-Encoding;
        b=K6HlMhlMsu7oZkbTG9OYGKVjHKuXPoFPf/DTSrck3+4MRLxv8vGw3KJviJ+WphaEV
         2uhly7sYISGT5+sbOHtyfg/3g/MCvZN+S235A4op2Ml2Zyyb/Cq+pFAhce+J18BB5w
         mG3t32ab8hvFZ+6txGb25km1RXdR8fDx4dQTD+ihxfkyCb1xtihvBrNdb6FWvlnCaW
         /2fkV0CTYUS4PL+E2wcYHn5UdIUi8AP4PfuT6C+I8SRQXJ5MxoaACeKrsnhjvg/Uri
         jdQ1AaRytr0u+aQPwC7RBmGkjmWjvD2iBM7GVdXNRDd4fSNIhBmcumXfBzEwNgsz9T
         s8MMvsYSC6uTA==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Background
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

I have a test environment which runs QEMU 4.2 with a plugin that runs two c=
opies of a PCIE device simulator on Ubuntu 18.04/CentOS 7.5 host and with a=
n Ubuntu 18.04 guest.=20

When running with a single QEMU hw thread/CPU using:

=A0=A0=A0=A0 	-cpu kvm64,+lahf_lm -M q35,kernel-irqchip=3Doff -device intel=
-iommu,intremap=3Don

Our tests run fine.=20

But when running with multiple hw threads/cpu's:

	2 cores 1 thread per core (2 hw threads/cpus):

=A0=A0=A0 	-cpu kvm64,+lahf_lm -M q35,kernel-irqchip=3Doff -device intel-io=
mmu,intremap=3Don -smp 2,sockets=3D1,cores=3D2

1 core, t threads per core (2 hw threads/cpus)

       -cpu kvm64,+lahf_lm -M q35,kernel-irqchip=3Doff -device intel-iommu,=
intremap=3Don -smp 2,sockets=3D1,cores=3D1

	2 cores, 2 threads per core (4 hw threads/cpus):

		-cpu kvm64,+lahf_lm -M q35,kernel-irqchip=3Doff -device intel-iommu,intre=
map=3Don -smp 4,sockets=3D1,cores=3D2

The values retuned are correct =A0all the way up the call stack and in KVM_=
EXIT_MMIO in=A0kvm_cpu_exec (qemu-4.2.0/accel/kvm/kvm-all.c:2365)=A0 but th=
e value returned to the device driver which initiated the read is 0.

I'm currently testing this issue on=20

    Ubuntu 18.04.4 LTS
        Kernel: 4.15.0-108-generic
        KVM Version: 1:2.11+dfsg-1ubuntu7.28

And:

    CentOS: 7.5.1804
        Kernel 4.14.78-7.x86_64
        KVM Version     : 1.5.3
=09
Seeing the same issues in both cases.

Questions
=3D=3D=3D=3D=3D=3D=3D=3D=3D

I have the following questions:

	Is anyone else running QEMU 4.2 in multi hw thread/cpu mode?=20

	Is anyone getting incorrect reads from memory mapped device registers =A0w=
hen running in this mode?

	Does anyone have any pointers on how best to debug the flow from KVM_EXIT_=
MMIO back to the device driver running on the guest=20
