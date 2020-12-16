Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84EE2DB9DB
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 04:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725841AbgLPDzM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 22:55:12 -0500
Received: from mail-eopbgr760115.outbound.protection.outlook.com ([40.107.76.115]:1443
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725550AbgLPDzM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 22:55:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DQN9zJwPHeHEccWqLfe176WtQkttJAMn6Wqp9bZzZholuP0PTp4nAWZWiu251iaHHjbgWiRtB9l4FecBgVBgMp9QlofU5k/afBgbrVw8Kd4TxgBpcien++8Y7vnx+ef5ndmiKQhHTZSHtLRBVFc2tSZBdg3bQRAZB+oDSJdhalf3CYQACtxAq3gAo4tU8rc9smLY5gnMgsI9gWBFh0uuVM8m8Xog3Szb8NL8P4aF0THD8k1UIpuXoORNHIVPg0qjnT4ulA4dwNubrLYp27XMmB6YIetxFNTqpD5trMwPQY+ROjGlELIK+xj2hlPDHPsjdNtDkn1xOsNRqzSXFbjQ2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bgUyZvlB+b1KHI0Lo6uDSrawrtZQUb2GXWRAKAkqxf4=;
 b=aM8zXmUVXgAfNfAvfX2ReOwTLWRPmnPRhg1zo+mzUCLqjuVLaV2ahBuGOI45ggqZcyzl6FMsm4Hn35YGWZJ9FqeM0LUmUQcxRpsrfPMozR2KlU6yp6YAbPGyo5VGS/xY+fCpD2VONE7DInhtJocQnMQvcxQ6bM2s60C9ya4Q400CXlz5QCBPxWBtbEAXST5kVLmdbFL3WXikO693n1xSMclq43O/34WWF69qRArNNrWaJPgn2LMwruPoLRMUadtFLB57JZnn1BxdLWOq1gx1NEh6rdM4hHPyTwsFjE4zFELRv/zoDSZtzQz4g/DTD+P/Mw9uMJWve1nrX2MBs+egYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bgUyZvlB+b1KHI0Lo6uDSrawrtZQUb2GXWRAKAkqxf4=;
 b=FJYvSyNq2xK6yUPxMa2Z62TlrTBJabmzZAkRPNhiU0c/BEWSCdTFjkiQASBV5F73lvA7kkx0WwYYiLsHZgiCbB1SJpaMjAczzXM9YUkCM/tWYfQADlRUyAMZMhlfC8KAbeGhQSqmp7uXC1d+ZMTzxV0RmKySci6LhsbUgK+mnLI=
Received: from (2603:10b6:303:74::12) by
 MWHPR21MB0639.namprd21.prod.outlook.com (2603:10b6:300:127::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.8; Wed, 16 Dec
 2020 03:54:29 +0000
Received: from MW4PR21MB1857.namprd21.prod.outlook.com
 ([fe80::f133:55b5:4633:c485]) by MW4PR21MB1857.namprd21.prod.outlook.com
 ([fe80::f133:55b5:4633:c485%5]) with mapi id 15.20.3700.012; Wed, 16 Dec 2020
 03:54:29 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: static_branch_enable() does not work from a __init function?
Thread-Topic: static_branch_enable() does not work from a __init function?
Thread-Index: AdbTW3KiWdYv++9aQjWyNkn3nWo7IA==
Date:   Wed, 16 Dec 2020 03:54:29 +0000
Message-ID: <MW4PR21MB1857CC85A6844C89183C93E9BFC59@MW4PR21MB1857.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=cad3edbe-6569-47e6-bb9d-60ae53f80dbc;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-12-16T03:24:57Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [2601:600:a280:7f70:4162:5057:b066:2876]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3348ac3c-2b72-40ad-c6eb-08d8a1764a48
x-ms-traffictypediagnostic: MWHPR21MB0639:
x-microsoft-antispam-prvs: <MWHPR21MB06395EC916A8D3B5C2C9ACFDBFC59@MWHPR21MB0639.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3EjMyWU2L1RJW96YgT8YjYOBipnvsIi77Rz1zM98skxPX2xRaOf2rgV7nS2w+C+IUhV4BWwaBVWQcQI3/sMfFtA4/ulNdcmGaaENNgixAoPeF5wXx5eIqWFaw7oAeHMC/A26Wl1QjW3AHBB7zY2TfUEGnCmDPLhF6Khf8lvC7gsqhuMN37q95rqwJdsjJbM9g+aJJVr7gUWKRpNKvIw616nCjV1WO1bmUYSYq9qsMWogGa1KkwhWMSgNArreKYl3CSHox2/o7EVseE5qEuaNReiNot2vTThbzsBQ4Rz081pT+6an7Z7aQ6G6KO/89GsgVt03cJLX2C2R+h9zVJ+b6c5rIltN8KttlgpMpGld7gBvijVQWLHbHzqwWIOrmAJ4mNu8sgKgnlKH3H/R3phA+Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR21MB1857.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(396003)(39860400002)(366004)(8676002)(2906002)(8990500004)(82950400001)(5660300002)(82960400001)(4326008)(7696005)(8936002)(186003)(6506007)(10290500003)(66556008)(76116006)(66946007)(66476007)(64756008)(86362001)(33656002)(478600001)(9686003)(52536014)(71200400001)(55016002)(110136005)(316002)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?p7BQdwWZgLtd8IBsqmqyS7uJZe3VOLQ2tvEqPTPcC9JAhzaGQhMjdc8AlAv8?=
 =?us-ascii?Q?AMJMjVMLAzv/hgddM6cJzoOtFiC89p+pk6cl6OLtX9U5ktYwHq8z5a/zyuMV?=
 =?us-ascii?Q?u0BZhJWbqu/1MHFx3t5HynRAFGVjQdKjgpQ+TaJq02MHVLITdLdEzfakRkhp?=
 =?us-ascii?Q?WrR6vyM8+I3SdFdfdbACwK8L8IuB+4oGyB9Egs1XIx4khHzFFM7h/kFjga69?=
 =?us-ascii?Q?dzCSc4onIViYsbOiG5unrYMkYswvb8gADsImtL5PbVuWoT2fyxiG0bYJD95M?=
 =?us-ascii?Q?0+CLFT/uK+2HaMT3/FaiKUpheBX14vIUX+QmTuaVgXgl85QB3W0rTsXzmTsk?=
 =?us-ascii?Q?x6ImelwwDnbDv73FXbyom8f++1zFWcIulymMsv8JYKJjhLGxVad/BJp7lSj5?=
 =?us-ascii?Q?y9WyFlKvZWS1fYSf5AHuFSjUqLiR4QaZWdxb2TDHzyUtPzWQbewRdrpkHGYb?=
 =?us-ascii?Q?iNr7DySy2RnLv2BAdbY4LNRTOG2aZ9VYy/M1CJDoa8vxHZRku0g3AoVbyxXU?=
 =?us-ascii?Q?YUCroya9eqeQQG8UOB8SNrsaE616cqZWni0508O9VEnKFtaeSzaIFCzeh32J?=
 =?us-ascii?Q?m0oMCEJqj6Tw9CAMImO6GAJMtKHd4gjxJxlhQkg4AJhH9XpZolWdrOR/HzyZ?=
 =?us-ascii?Q?xiFI83XBXpa5NH445XhPMjsYWXU/tKpjZCXs4Lgo40RiJPh9UxNEe02Sn/sG?=
 =?us-ascii?Q?M+4qoxRbrLjlRFpEno7lar6QV/QIL/0voVa3d4i5R+HGqpPmqKlesrIgphac?=
 =?us-ascii?Q?bHhHnwVg1pg1N0BOiKvTBToM3usG5n+fOlmvlRnu8xvuZV3sWkLFoeN2RL+H?=
 =?us-ascii?Q?ni7gHIoQg/SCVc1q8BGd4FmVfJrdyZ9B2wJ7CVeEGiem0XgrxWEebamkR1UC?=
 =?us-ascii?Q?9FEyn25WrlOBYCLrn7oyNx/GanHS+/IH4zRBJPQzVA49JMsXhPDJAhaqVjpf?=
 =?us-ascii?Q?zaS/4spa4g6pkcOLyZhL+nemTcuzLU/92pVOfsaZQcxf6UjmWP68n1ZO8IDc?=
 =?us-ascii?Q?OXRgD7j93GUCJOJ0HkqfdWUmPY3RoZsVJdUM2DmghxWq+Ac=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR21MB1857.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3348ac3c-2b72-40ad-c6eb-08d8a1764a48
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2020 03:54:29.6157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mlutSdxVVDh7kyesKZDsh2rc7LB2FVoQ+wtM1DOOuVi5LKNKW9sFUvaYo/EpKbmjKIT64eKvYzEMsW3hR413Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0639
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,
The below init_module() prints "foo: false". This is strange since
static_branch_enable() is called before the static_branch_unlikely().
This strange behavior happens to v5.10 and an old v5.4 kernel.

If I remove the "__init" marker from the init_module() function, then
I get the expected output of "foo: true"! I guess here I'm missing
something with Static Keys?

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/jump_label.h>

static DEFINE_STATIC_KEY_FALSE(enable_foo);

int __init init_module(void)
{
        static_branch_enable(&enable_foo);

        if (static_branch_unlikely(&enable_foo))
                printk("foo: true\n");
        else
                printk("foo: false\n");

        return 0;
}

void cleanup_module(void)
{
        static_branch_disable(&enable_foo);
}

MODULE_LICENSE("GPL");


PS, I originally found: in arch/x86/kvm/vmx/vmx.c: vmx_init(), it looks
like the line "static_branch_enable(&enable_evmcs);" does not take effect
in a v5.4-based kernel, but does take effect in the v5.10 kernel in the
same x86-64 virtual machine on Hyper-V, so I made the above test module
to test static_branch_enable(), and found that static_branch_enable() in
the test module does not work with both v5.10 and my v5.4 kernel, if the
__init marker is used.

Thanks,
-- Dexuan


