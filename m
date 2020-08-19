Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460382495FD
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 09:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgHSHCX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 03:02:23 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:30942 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728203AbgHSHBt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Aug 2020 03:01:49 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07J71STH031566
        for <kvm@vger.kernel.org>; Wed, 19 Aug 2020 00:01:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=ua+QkFLnu6isxVk48VZ2nDAi9mw+gxyH+c25vTVh8d8=;
 b=IP7ofDsxF6MckRBQhe7EgQt8n9wgTHo0YA/he0GmlPFjgeEWWQOua+txQgSvDaCYuEgb
 aOqFOjhejq8bEcIXmEfLaLJFkDILAQ8Bk0vSw2G1l1NaBhAAI5d4uM9BP0h3wHfqm8cg
 LRVhGlbjz6o0IWLC9ac36MHvvMoRJK1ahR1WouS/aIuUjp7BYRfSeHpielFv/5OkFokA
 jotReo5lq2SbliNu8nL0amk5AFTcVF8JXXORp/h6QMPLxA27pQN/goYjJy89fdT/IoKe
 dvvMxU6oOOw9mYN7KF+zI2rnXNWUrx+22oESdOLK/RQN1k4Z1EUMRnWniyZAd2npsVf7 JA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3304fhpm02-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 19 Aug 2020 00:01:31 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 19 Aug
 2020 00:01:28 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 19 Aug
 2020 00:01:28 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 19 Aug 2020 00:01:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JKw67Q+XUMo0AtnE+fWrKgxOwwC4BRY7WB92/sbDCd9EBCoOGPjiCRAn/9leJaYvvFKJbCKM3XqFNcZN6jewa5QwMXHTlx3If7NkGiwFvc0nASNmEvJtoSC0ymFwBTh72j3vS6lACDCrK7ZW/lZ5wJIL4wYq7UKSlghVkD9seIK5wZ5lkyjfE/l1ChSCrD6oloxSnlmHWfyBNFzPqQSUqsWVsZbFfX+Zi0r3ORM6MHpmGWyRqSbsLGp03foCvJYS0swD7yArWbPOpFN3VmIa/qXJK9HNlWn9ZEO4vX7k4bdlBGYMEGj0IGRkpll006hTJGSAvQRU/Bmf5LGy6d7l9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ua+QkFLnu6isxVk48VZ2nDAi9mw+gxyH+c25vTVh8d8=;
 b=OZT7UENt6Pqyfk2JX1RC0lfdAr5due+8ZC+YeEfhVnKCD2HqGSboj7KoYQ3ybAxiYJ4Lf+MHrzA9/uVfbtX3qY0LOy8QqSNXjKVlQynTMCClUFZg/mQE59JAafnvIwQH7p7UBENgm953/Gyx1eirEVgG0iX2IyeTS1eygXnTWLaf6QuicIw1z8OEm5LZ8gaqy9XyRiDTM2GqyD5if74YLwarcTMbzPr2kkrcdZRbN8AIT0xOEpY7zACbBRgSpVqSdHttcam/nlyR+rGFMhKmDZCqfmRowYSVuQDlQU0rhIA8ovOiiZBkSnmRy7vmn5JHE7pSBlmWt8l7e2h/IySM+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ua+QkFLnu6isxVk48VZ2nDAi9mw+gxyH+c25vTVh8d8=;
 b=UBqA7AjIfPNUgDEBAXFt3CrXaAEChrSvbScECgZQeAEzbZc3wzauCULsXSHqcRouY0dyddcx1CWvCzKTC5mF22bDFqVwkdacdiT53UJ3s3LHzT3IZ4bnboYpf5HCh65Aji7NNfIAlAJ3+vQMbQgEXo+oY9BtEVM779GYH9ehJuE=
Received: from BY5PR18MB3346.namprd18.prod.outlook.com (2603:10b6:a03:1a8::18)
 by BYAPR18MB2741.namprd18.prod.outlook.com (2603:10b6:a03:104::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.23; Wed, 19 Aug
 2020 07:01:27 +0000
Received: from BY5PR18MB3346.namprd18.prod.outlook.com
 ([fe80::d093:69a1:ab35:d15a]) by BY5PR18MB3346.namprd18.prod.outlook.com
 ([fe80::d093:69a1:ab35:d15a%4]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 07:01:27 +0000
From:   Dahui Jiang <dahui@marvell.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Is latest KVM support auto rescan after PCIe device reset?
Thread-Topic: Is latest KVM support auto rescan after PCIe device reset?
Thread-Index: AdZ19oPqpelB+HfvSGy7IHynO6vK5g==
Date:   Wed, 19 Aug 2020 07:01:26 +0000
Message-ID: <BY5PR18MB33461224069C2248CE19CA90A95D0@BY5PR18MB3346.namprd18.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [222.73.125.101]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 951aae5b-4417-4c6d-ad5c-08d8440db130
x-ms-traffictypediagnostic: BYAPR18MB2741:
x-microsoft-antispam-prvs: <BYAPR18MB2741640AD5EA6EF60AF831A0A95D0@BYAPR18MB2741.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gYyVY/0OwRvo5vEBMpcd5BNajpy9QNA7VoeH/KfI/aF/VZebTYqhHrl3a9gCAQimEAaZsffDCYTR2XdUsSsEFIaFjcKuSCMo1myOomr7YdP0a/l9t06+CO6dIulE3sb6b0iLMYxdcLJ006oC43ha3YCDLsePliD6kyVhNioX5LcbubQ9wtCWNiL0Xs3x5FOu+puoRovD9fRP24LggOBHd8WjQx40qNkgn9RBXLZUwe6nwhER2WFcf8bcRAlGQkHmrHsBvuKjrIWS6R6W+wJIHWWp1yzqa83Mu5tiMnxNC5DSLgR9KZIxWM14aOYvWYr0847E+LSMsb8who9SEvGgsA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR18MB3346.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39850400004)(376002)(346002)(396003)(8936002)(76116006)(6506007)(66476007)(2906002)(66446008)(66946007)(316002)(66556008)(7696005)(64756008)(478600001)(8676002)(186003)(9686003)(5660300002)(86362001)(6916009)(26005)(4744005)(71200400001)(55016002)(33656002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: GgbRwkKwP/W0c2hNQO0WVZPLJ23EzrAKrspAggwGvsDOgsu5eS1cVfqq0ucr4RbT6tvv3cja/2td+6elNoMugK6q0w+nBlP7ZntlNynMlRgzNgCwGihKhMH68G0uzObPXIEAwo0q5cbUOyhX6mLnkHZMrGfWmDgti7d9ruUkN71d4jjhVh+GFNu9tTo9M8FT4xE+/t2IkTSnWJXw3GcxQxNf9n1LSz6cvpI/QqP11ZVBh0bIgZNTLQwcuDKHwyQnjOlOiN1RVj/UVMeeYIYNbNHxOLc2qfY/ENaTIv/zXKBKYAum5pQ9cdPT5RBqYKYuwJ3tUKPAABHurAoIdl5/du71b0uI/2M6OScn1wyqdbrxJhj4le2faEVvhG4KpZkB1h5fagKMffa9b5zihmuPBqBu7fofocd4o+dAdFqBFqHFAEPD3qNmDUgLdYeeHn0TzbnBNzQlCookofaGh+JDy416xiczwW+mfXfyXoYE5Jl3/W4uigY/CrAhDzrmDL9+llsJaD2Mf8sxD6owCpmfbAqWasyffdSn2xrVFQ3lYlg8xaii3LhJKhSRYSoWF8pXJ+4v2IMTTKsLv6P/kRpCQVR5BectK+/2vVRjB7nkUieBdyMvQ1ArvTPnZkysN9erWq/riVdBWgDW+X0EHx5n/Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR18MB3346.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 951aae5b-4417-4c6d-ad5c-08d8440db130
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2020 07:01:26.8587
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Sx/TFJiinxuqCPX/csjVRzt+W4pP56nrIQ1WHnj1+X8Z1qPcR79JW7/UtamJJ/ld/hoJcQhVPEk/fMy+8DTWcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2741
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_04:2020-08-18,2020-08-19 signatures=0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all:

I use KVM on Ubuntu, the version is:

root@PC:/home# qemu-system-x86_64 --version
QEMU emulator version 2.11.1(Debian 1:2.11+dfsg-1ubuntu7.29)
Copyright (c) 2003-2017 Fabrice Bellard and the QEMU Project developers

One PCIe card is used by one VM by pass through, and the PCIe card support =
hot plug.
And I found that after unplugging and plugging, and PCI device being listed=
 by command "lspci" on host,
the corresponding PCI device in VM can't be list therewith.

I have found workaround like rebooting the VM or running command "virsh att=
ach-device" with a xml file defining the device as one parameter.=20

But I still want to know if the latest KVM can do the recover automatically=
.


Thanks
Dahui

