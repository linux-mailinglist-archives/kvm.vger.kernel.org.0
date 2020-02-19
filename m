Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9C56164C5D
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 18:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgBSRoE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 12:44:04 -0500
Received: from mail-eopbgr00092.outbound.protection.outlook.com ([40.107.0.92]:44162
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726582AbgBSRoE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 12:44:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TEIDRwetZTLZ00ekhOYfDs6zPyxFulxCKRBu6jnkOjhI/YwkUdlluaY4SbruWR6GB2hfdkU847sisYXKCUlS4Z/+hWMG2zISdvr8GMwgwL+liGBsfOEFKNlfHo40zFm2f3+Vh+Z3iNoCr/RPvWFy0w2me4niG5C348R2+xuJK/nTNvgUa6dFG6wvMR5+ofJTGDZJzECmNZXA7EH+fSjpc6CIBU3Lln0ZHdhDsRO70FuDF/iA9f0JRNwB/xTmZDVYQGopMQdpiMHr0mpusNYu+XjAzBtZUPijZCLPriAi4SXgUsdC5gX0aaVw0msxdN8MZanjiL1DXer8Ym+g0ddl0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ImU0+VoYGqwJ1CgP4EtRw0mK35XDl7AgW9evSxgwRSs=;
 b=cGs5EXeytDAuKA2OGwARyITROVO++e8BT3JtQw36h6a+8gNDd0bgCYO0D7fe3b4osgWvXNIsDgIc5/ZZiKrN8+rwcBBx4ahdgZSEnUcXHUFdF034JT24wR0tfl0f5Ifw5AawhcBGacItdNXn3d01oAF5Rg6AYdlk3MdCgsFGl/8u0GbyJX25x1u3RYXm2SGYtURcCpIDYD3fOunOCZ+5+8QDVDUQd71LJznmknPrm/n0RBkkeMKTA3+f00SiN2fiGvqK/aV22u+onZAEzs5j0kiwhp1aBWKiUwfFgRoMYdwVw5LtWwdF8CBaRW6JxX9bClSvSuX6JFjrsF2R3dJ4Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=criteo.com; dmarc=pass action=none header.from=criteo.com;
 dkim=pass header.d=criteo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=criteo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ImU0+VoYGqwJ1CgP4EtRw0mK35XDl7AgW9evSxgwRSs=;
 b=P6O6kvX0eM4lx5Sj6Vg1vhu0CmDOGc6YaeZnPEDFtfcCdnD9QxVnrlCXU1cs+gazdudX/WzfGQ73wVDNcMQsEbxoPFnbPLhXfyR7RsM85oc29jQ7rW/M1tC//4KX6vRkIhwlyLis9R8ddw1GbemnF4hBcoURwcZKttmAvnpPjyE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=e.velu@criteo.com; 
Received: from VI1PR04MB4926.eurprd04.prod.outlook.com (20.177.48.80) by
 VI1PR04MB6126.eurprd04.prod.outlook.com (20.179.28.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Wed, 19 Feb 2020 17:43:59 +0000
Received: from VI1PR04MB4926.eurprd04.prod.outlook.com
 ([fe80::99f4:5892:158f:5ae4]) by VI1PR04MB4926.eurprd04.prod.outlook.com
 ([fe80::99f4:5892:158f:5ae4%5]) with mapi id 15.20.2729.032; Wed, 19 Feb 2020
 17:43:59 +0000
Subject: Re: [PATCH] kvm: x86: Print "disabled by bios" only once per host
From:   Erwan Velu <e.velu@criteo.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Erwan Velu <erwanaliasr1@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200214143035.607115-1-e.velu@criteo.com>
 <20200214170508.GB20690@linux.intel.com>
 <70b4d8fa-57c0-055b-8391-4952dec32a58@criteo.com>
 <20200218184802.GC28156@linux.intel.com>
 <91db305a-1d81-61a6-125b-3094e75b4b3e@criteo.com>
 <416e20b6-8f21-5949-bf51-f02603793b49@criteo.com>
Message-ID: <5fee0f19-e926-47fe-e213-913bebf6354c@criteo.com>
Date:   Wed, 19 Feb 2020 18:42:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <416e20b6-8f21-5949-bf51-f02603793b49@criteo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: LO2P265CA0325.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::25) To VI1PR04MB4926.eurprd04.prod.outlook.com
 (2603:10a6:803:51::16)
MIME-Version: 1.0
Received: from [192.168.4.193] (91.199.242.236) by LO2P265CA0325.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a4::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.25 via Frontend Transport; Wed, 19 Feb 2020 17:43:58 +0000
X-Originating-IP: [91.199.242.236]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6109b2ce-5fd4-49a6-a690-08d7b5634d04
X-MS-TrafficTypeDiagnostic: VI1PR04MB6126:
X-Microsoft-Antispam-PRVS: <VI1PR04MB612650D5E4D0735B11F922AAF2100@VI1PR04MB6126.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0318501FAE
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(396003)(346002)(366004)(376002)(199004)(189003)(2906002)(6486002)(956004)(7416002)(2616005)(52116002)(54906003)(8936002)(6666004)(66556008)(66946007)(36756003)(16576012)(316002)(66476007)(6916009)(186003)(16526019)(86362001)(31696002)(26005)(478600001)(4326008)(81166006)(53546011)(31686004)(4744005)(966005)(81156014)(5660300002)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR04MB6126;H:VI1PR04MB4926.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: criteo.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mrt3VhG318YcnAzwBcErfBV9TUxUQUyM03gDzIYIMZGyVGFU623wIT+SMojDLwNf7EMz1gPU5IAq5ms0kIzVuhhbc0Dau1WHdh2DdZWkX53V3GVPsXyxmyeiggD2SkvNsLCZQfZ3jrbwK4eOqCVguGFhauPXuAjE95bAiE8gn9pP8r1lga0HLYdG2OBYHD0fStE+hiVSBPo3GhamRqwS0RKR9nWwrnQoRzyLjDMVhLQFnnzWiCh1DNgwGbNVLLqFX3YxPlMFuWmNbPDyiJ6tVb3xDKPM3s0UCcFrkgf1DwL1WvylkgvgwgHBePQ538TIfow8TXWRcbnbmId4tsxbPzq6qIvTNJ6kr4JNzmGzIy8l2wCvpq0O0RMtWE+Eo7Tfs2wSP7jyvkK1oghQjDA/ajcsljNzDIwWBijPK9h35sKnAql8bnZJJXmFaeG7PZzgVfeoT7A5plFJBA1DdtpU5GuILiQjMhU3vCnDS1Tte4IbRPFTdb/is5+19moSh3WM2gUiV0AtK65l7G7K0uSRCg==
X-MS-Exchange-AntiSpam-MessageData: 0sahV+eBLTHTcJFF0i1cmPmBHyE9SmxnDKfQb4xPf0J3RiW9xeIOObqmgDsRvBGqxIRz1QmjuasNIrs1m+jtJQ1VhHNEgO+s++J2YQEvgo9fCtx5MPj4WKJYzxpTCoz+PiAWv4d8phLoD+kpkQkkNQ==
X-OriginatorOrg: criteo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6109b2ce-5fd4-49a6-a690-08d7b5634d04
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2020 17:43:59.6243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2a35d8fd-574d-48e3-927c-8c398e225a01
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3V3FaRq+8ofrcQteaCFzWEcMWL20PrcMKsjq3vRTj+AAkD6YtdU5I5UKVqPaMlrNY4SDHWsOHwtNAeWlniWkGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6126
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 19/02/2020 12:32, Erwan Velu wrote:
> On 19/02/2020 12:19, Erwan Velu wrote:
> [...]
>> - contacting the udev people to see the rational & fix it too : I'll 
>> do that 
>
> I created https://github.com/systemd/systemd/issues/14906, if some 
> want to participate/follow the discussions with systemd.
>
It appear that its fixed on recent systemd, I tried at least starting 
from v239 this is fixed. I didn't tried earlier releases as they are 
painful to build.

To me that doesn't means that the ratelimited printing have no interest 
for all existing systems unless we weren't at least two reporting this ;)

Erwan,

