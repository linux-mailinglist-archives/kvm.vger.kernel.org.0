Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF01372A10
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 14:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbhEDM1u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 08:27:50 -0400
Received: from mail-eopbgr80103.outbound.protection.outlook.com ([40.107.8.103]:31395
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230293AbhEDM1t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 08:27:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lwHVfn45COyOzQGJp//XwvhnL7eQ0uUjqJi9HSHhYUin2inu5uwlla7MRzYJlkMNF1P3VhB3xrQ4aWhcsB2O/ib6oDKoZCo3FbTsmTq2/KSJkCwctlp9UcJIqjOf0OEZXE8QeeKQU7VI7F48H48iWoFIFCudiupA6GTNkcHzM76ZgXB86/a6cUraFPxy58fFjMcw4XRbiQU1GfkwsEZV5WhxRI/29z31lIK7soP0UiUklu9WqRnaZVtv4FMSgtFQVt7KylS8QOtrPE9uSTC5oktw8JHK/Ac/TOxtH51tE2/l7QwfOujtqSXu/6ML7AGiB8mKU2LZCXbMbbXKmmDHoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dy9TocU303aflyHSa+2gYdVGUNgQTkBiJtVrqZ8jY+w=;
 b=dyLxc0LW9JYQ4+cBiP6ml5wn2RFKfJmEvWO50qSaDdnZoh/Mmwc5B15w12RX+pu1TZGKdfgaSgvEATu4GxRXtupFt7bs3SGgkl75FeoNADCjYgY1AcnNQdO6WhiWOv8vhDkfZJCjGmB55bdIT00crIV5nAdkOvavmfoG9XFCNtBtHlW/a1l/xzplG8J47p8GsL39rL0m14caYFY4HzmUJurnHMDzQC0bY+TTaBY9uVKEDJ4v6K195VTwWHCYQBC60/RUiLlPkLFdwqTjVqGAJVz9vImUmfJj97KCdQlgipmWQlPpF62AQ/HCb+UjDZcVPWCVEeqIwliTd14fEqM4og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dy9TocU303aflyHSa+2gYdVGUNgQTkBiJtVrqZ8jY+w=;
 b=ppPiAAOoqN6xDwX2Et2oUDFGXhhEK1dhRqknCKV/mbFF74r9mNRw9Lh8BQn4lUgHH/T3rXZTgA3u0euaCOGfswIA6pkXJWzx6RRWPpoVQeGdEoPk3WLADYgxS1CCQxASD4jiJ1MDKdXsKxmUmLPxoSp+YJeyhKYP4qZQSvCMnII=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=virtuozzo.com;
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com (2603:10a6:20b:283::19)
 by AM9PR08MB6998.eurprd08.prod.outlook.com (2603:10a6:20b:419::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25; Tue, 4 May
 2021 12:26:52 +0000
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::7d3f:e291:9411:c50f]) by AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::7d3f:e291:9411:c50f%7]) with mapi id 15.20.4087.044; Tue, 4 May 2021
 12:26:52 +0000
From:   Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
To:     qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Denis Lunev <den@openvz.org>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
Subject: [PATCH v7 0/1] qapi: introduce 'query-cpu-model-cpuid' action
Date:   Tue,  4 May 2021 15:26:38 +0300
Message-Id: <20210504122639.18342-1-valeriy.vdovin@virtuozzo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [176.106.247.78]
X-ClientProxiedBy: AM0P190CA0027.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::37) To AM9PR08MB5988.eurprd08.prod.outlook.com
 (2603:10a6:20b:283::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (176.106.247.78) by AM0P190CA0027.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend Transport; Tue, 4 May 2021 12:26:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c48174f7-1b43-49ca-a5ed-08d90ef7e5de
X-MS-TrafficTypeDiagnostic: AM9PR08MB6998:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9PR08MB6998AA78684651E5DF1F83BA875A9@AM9PR08MB6998.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /+GZ2nIeBmjRfbrDsAQAd8d62Vw9G89XZEeG3iSYTeYBqGORxl8u0/BU/eGx5pLQMHtogb+FAoPDCoZh3MrfsFxFDCIJQqA+WRbVxFRSIY1fF4N2VGeitMQFcZYXiBoAA3zuttfeukDltx+cCNvs3+/V09l3BVixK3PDRRxTisIK3IzuakoHKCBzVaQ2MUk/RyoSQHt2UwQnvaL8V87NF6338k2gZQTunWiNTI5HHCoJ/Q56Q2JU99SGn3z6Cb6aMr9Vl0OEd4nETcKCIIZx8jfGVPKeLLkjefpC1N/eKhr5UtVYW+UTtdHdjjhVOZ0F+LJPkYB2iRImNK6+kUvxv8ezHv4dOkLPTGAiW8dTy9rm3V/VG+u+/C5fGuLHMArhTazd5uvYG3rWFG+e3DGOtTEkjEOQfIvTmE2NiD2Isismb8DfiAY3HWqZ4m6wTr1LBPVJF/vW9mmduGHtT21+Zkyji1wmr4fMGZx0w77g1nUZqOEk3WvSzvWP2VkDjQqHw9NxTLgsPUXYsPtvxdv8iNzNzQZIAyHkqpb9qEUTjweBILUTNMoKlfUZI/kDUePykU7kZtRb7HPPO2tdWg+GzN6KP1ye72eGSL4spcEVHHsxqJ+Kl7OLtpMpTefrFS8WY0cWrymBteylgnmo+Qpknr3cEPaXhyoJzxeaun8T7AtMeWc257+UUyQlAK5bDP0WfqFJGkipz9ypgTOL5oNCRPdlnKL7AbBy5Rt5ISrDmbZmUaRMw5NpVI41fTXnqmZpgyjzHUpkaNtWyD9T7XraQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB5988.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39830400003)(346002)(136003)(366004)(376002)(38350700002)(6666004)(186003)(16526019)(478600001)(44832011)(4326008)(52116002)(66556008)(36756003)(66946007)(38100700002)(66476007)(2616005)(6506007)(107886003)(956004)(83380400001)(54906003)(966005)(6512007)(6486002)(2906002)(26005)(8936002)(7416002)(316002)(5660300002)(8676002)(6916009)(86362001)(1076003)(69590400013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?XQehwhkZCynCF38D7pjBBJdelfzy6TkN+BD+33c89KaTHOI99xx+2UHWaADj?=
 =?us-ascii?Q?1xX+P0af8LGXTYac27WHKZuBvAq54/1dEek48jWpvSArQiBf1b/D1tXpFSDw?=
 =?us-ascii?Q?s0Z1On88ghkTE1N+ADjQQes51tnM8fLzECmID9DXhM565FD0Brz2M4eResDV?=
 =?us-ascii?Q?B25sUt8x92tl0LU3rHqn5GmPoFg1pCbAaJrwWBm5xNtZbP/Ynn2FP2YjFBwY?=
 =?us-ascii?Q?O2Y8Cetvhewqge84MCkRopefGtAVtJzCHaMlNFzHKTdZCJmwgIWV2rvRw5Hu?=
 =?us-ascii?Q?HRACVnhN0aqLDTr6L3lbByTkJj1Ha7l28FS/59Oc8Z+PV62pppj8We60ffRQ?=
 =?us-ascii?Q?hOUWiG2Nh01DSbJaeXs9NSZ+FemKeraB0SRbCnuNhmu3xntyR6O2vUC8jCAR?=
 =?us-ascii?Q?TNJRvWonOJPLr5D53iaTMxZWdQk4kzDun+Pb1E/5AapXt42oXV4aqdowdVF3?=
 =?us-ascii?Q?U+KqzY+1cAwjaIwjR2Wzn/GihFe20mHw/R1/EUTtfMQDY+FKs7qziEIUOSHo?=
 =?us-ascii?Q?flbNTZHaUtEdXehwd4gV7RZzz2xtsEXU0c1DGwyPtwc9/7dYfBGBX24FqmXS?=
 =?us-ascii?Q?92fARxXWnhpT67w4aVWuebMYRADjaG3IVorTMU/5zUh4+4nU5t65yF01HtgW?=
 =?us-ascii?Q?Dl5DW5rntFR7dgfIoAodik59VcyfNiM6nz+JErQryhsj6xsW1IJMMiEyyO2y?=
 =?us-ascii?Q?A6PgVDjojH+uIxy+HuENK1G3aBV4EoTTZRtoF6W9QdVbby7/ZR0IAqkNTW1V?=
 =?us-ascii?Q?XscLhD5gQqjXknMpZ0DH1JJ6pgL7vTNn1/fxgBdJAatuELC7u1e0xeu0Trmc?=
 =?us-ascii?Q?IlbTKzJxw4JpdHgWFkmV618+JR2iO3DxyzR/bscDxz7d4/oYEn9fsFnh2ln+?=
 =?us-ascii?Q?4Ub9hLMNfZRnUfE1Yt/ZSaBl0TdO4SqOEq4GlcZJnU92LhrfdbhkSwhOfAyn?=
 =?us-ascii?Q?npZlqYz9yWjnLV4evIWQO2eXSBIqJm7a+aDSHd0qzzaLtH2Kz6ue8fu2ybma?=
 =?us-ascii?Q?uWv3gT0PjvlT4gePm5pwg46VnCOk+Kbjjf+qAZ2Bkw5mGpbQoHSA5vyMPCsX?=
 =?us-ascii?Q?ATfs1Uy9sLQRufYcOb5dr7Fp/eCyvZsN7e7lDa2E3Y5gLKARcpcDUzUfofVh?=
 =?us-ascii?Q?BaO5Rmj8vTfDn9fJ7Almxw6bwh1P+q/RH40GeAIdD2AavqQrnVXXGmG2SexH?=
 =?us-ascii?Q?v1jL6JNxd01o8aB+/h6v3NiGB3CgFdVRSpzZiq8Nn2vAWiAs5ZNYze5CU62S?=
 =?us-ascii?Q?Je7mzRcmPeMMP573PNQF4mKoFCMS/JOWLUnacCuC8zF2vMxYLj1c9Jc4FIIW?=
 =?us-ascii?Q?axxFYSIm/0mqPe1mXIuBmFGA?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c48174f7-1b43-49ca-a5ed-08d90ef7e5de
X-MS-Exchange-CrossTenant-AuthSource: AM9PR08MB5988.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2021 12:26:52.7852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6eBF+jfc3JjXpEUOpY8ctCsS2J40Jlu3fY5UeA7MIqYXl516yirg2chv0H9LD5T9XLLJi4ngnikU+922unV7jV/BX30priCf/gV4n0ipmUI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6998
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In version 7 of the subject patch, I wanted to try to implement this qmp
method with the help of existing kvm ioctl KVM_GET_CPUID2. The reasoning
behind my decision is the fact that QEMU uses KVM_SET_CPUID2 to set full
cpuid response table to the virtual cpu, and KVM_GET_CPUID2 is a convenient
and complementary method for extracting the same cpuid entry table back
from the kernel.

So I've pushed a patch into Linux KVM subtree to fine tune ioctl
KVM_GET_CPUID2 for this type of application. This has triggered a small
discussion.
One of the responses here https://lkml.org/lkml/2021/5/4/109 is from
Paolo Bonzini. There he suggests to cache the the whole cpuid entries
table that we pass to the kernel via KVM_SET_CPUID2 and later just output
this cached data instead of calling the same table via KVM_GET_CPUID2.
Current patch is the reflection of that idea.

Valeriy Vdovin (1):
  qapi: introduce 'query-cpu-model-cpuid' action

 qapi/machine-target.json   | 51 ++++++++++++++++++++++++++++++++++++++
 target/i386/kvm/kvm.c      | 45 ++++++++++++++++++++++++++++++---
 tests/qtest/qmp-cmd-test.c |  1 +
 3 files changed, 93 insertions(+), 4 deletions(-)

-- 
2.17.1

