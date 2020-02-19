Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 808D1164B28
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 17:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgBSQzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 11:55:20 -0500
Received: from mail-eopbgr150108.outbound.protection.outlook.com ([40.107.15.108]:51452
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726528AbgBSQzT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 11:55:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e05WwZrTgKxidXccki1aT0F2rr6pG84qSZLTrAuIXndG5j5ekUIVdn7dg1o0ZzSVrePkYfzuL5CofjTEsKKS6LFKe4BMIqDtx3Z+3JMTub/q83MNViWW2vpHGGKrqTsGMxnccRTTGGbZqcCO1BeTQRgT0SDLlvXw+UGcZMLKZPn90xhgN4VFd2sDMShpB/xS2sxHVKqIpKLvnH7I3hYYt5U8+Z/KNsX9TdBJrzIpUMJNyVZGfjyeUiUfe2tS5WYrBVIxIWO1qsMYioImPoDO5vODeaQE84l/LfGh6FlqzsCjg1yz360P+5P1ZSpm//IiCdET7e77TX2yoR8Sfdebqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rHl9EJJ7po8nT3ZbsDbBESrFzHDha8JioZVdpPCJVwo=;
 b=L5EWPMAcvbV9EXPkzp7D1svkwDx6f/9oaWxLYq66PIdGf83YtW2gFfTPMsHbY+mhDjgSOBPbvgwbsS5XS0pPrl2ln8YzK8G2e+XVSe3cnMFtIr0PDszv0FsBYAOEgOmajH1h+eWv8zkqjJpLy2S5NEc8hZGf57rX2nmczVKII1v0QWiqJugNqGAZ8M6/Rj147BIyJoJ52+h6SiBBlnzDCUFriMzBVV3zi+kOtrBwzLXbbt54IKlUwplIjSA4nZbjIoWP1ljiAbGdfcvldoDIbfB6FE/g44vUsYfAOq2FDD6aTVbhc7tetHsATj77BcqYIqB4sfU71NFeh/r6VZM/rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=criteo.com; dmarc=pass action=none header.from=criteo.com;
 dkim=pass header.d=criteo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=criteo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rHl9EJJ7po8nT3ZbsDbBESrFzHDha8JioZVdpPCJVwo=;
 b=Fc02m0GGTWNtUC5bcgrIreGiHlT3fx14jkl2aMVDzAC12ZcQReKWfNDPNFsyQfBiiYBfGNoRhnUMDbBGcbc2mg1foKWCheg0Qbj5xjB53TE2haYGvQ7hRCrXKx7Yh1Zl1yfY/sYJguD3CbD6FO75lKcSSVMZVDU9hitUbS/HoXU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=e.velu@criteo.com; 
Received: from VI1PR04MB4926.eurprd04.prod.outlook.com (20.177.48.80) by
 VI1PR04MB7133.eurprd04.prod.outlook.com (10.186.157.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Wed, 19 Feb 2020 16:55:14 +0000
Received: from VI1PR04MB4926.eurprd04.prod.outlook.com
 ([fe80::99f4:5892:158f:5ae4]) by VI1PR04MB4926.eurprd04.prod.outlook.com
 ([fe80::99f4:5892:158f:5ae4%5]) with mapi id 15.20.2729.032; Wed, 19 Feb 2020
 16:55:14 +0000
Subject: Re: [PATCH] kvm: x86: Print "disabled by bios" only once per host
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
 <20200219161827.GD15888@linux.intel.com>
From:   Erwan Velu <e.velu@criteo.com>
Message-ID: <646147a6-730b-0366-10db-ed74489ad11e@criteo.com>
Date:   Wed, 19 Feb 2020 17:53:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <20200219161827.GD15888@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: LO2P265CA0031.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::19) To VI1PR04MB4926.eurprd04.prod.outlook.com
 (2603:10a6:803:51::16)
MIME-Version: 1.0
Received: from [192.168.4.193] (91.199.242.236) by LO2P265CA0031.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:61::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Wed, 19 Feb 2020 16:55:13 +0000
X-Originating-IP: [91.199.242.236]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93142053-3230-4579-d6d9-08d7b55c7d46
X-MS-TrafficTypeDiagnostic: VI1PR04MB7133:
X-Microsoft-Antispam-PRVS: <VI1PR04MB71332590BAA5F0B8271F2C6BF2100@VI1PR04MB7133.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0318501FAE
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(136003)(39860400002)(346002)(376002)(366004)(189003)(199004)(31696002)(4744005)(52116002)(6486002)(36756003)(478600001)(2906002)(6916009)(86362001)(956004)(316002)(16526019)(31686004)(54906003)(8676002)(186003)(66556008)(66946007)(81166006)(16576012)(66476007)(8936002)(7416002)(6666004)(26005)(4326008)(2616005)(53546011)(5660300002)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR04MB7133;H:VI1PR04MB4926.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: criteo.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1hppuCjeq6Oc+8ZiyT/mr9ni5CzrdrMIcBw5QTBEa5QVbPb+7FE+mr/vVCNUWaEJG+akPYi4wIgTeBcvqPpqq757DnyayBhyMc4KiXu26hNd+ujyhtdIeTghjWEuQLuBHsv9TkQKZR7ekCSmiNl8cZ+S+P2bVeiwcGOaExDj0hettKWcZSftQciodafyEpcTpffjG3jCsbA4uw6mY36dslmSg1Ebo8kYz0g0BoHFO3dFm+Pt1CIopNVZtun1fz1NL6cIDwefPh+FSIyU5rUMazC7VNEtjuP8mV5e2Q2oMhsxYtN5zauKWqX5xZ0Xld2en96auLNY4umbzykxjwljphfjFldEVw4ojhKR3nhAni68GELc4phvrL95L6bL4ov5sRbThcjNYDsLNoGXf5V4sMtfRInHpjyYTpPYUue9JJanjHX5Z/TAPPf2fvvNJXvw
X-MS-Exchange-AntiSpam-MessageData: yXkwFnmUPCkyTYkkNDTXQ0obvh0wBaFDncuCpWsyQF1cOya/mSET3aIQQALC/589UDgoV1os2xWnrEUzlBX1EfcojqumgbLPD4bApqMslsiLbKEztkWrm6HnZPaY1TrD7YxiBY3X1Wg3d4dLHQy35g==
X-OriginatorOrg: criteo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93142053-3230-4579-d6d9-08d7b55c7d46
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2020 16:55:14.1436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2a35d8fd-574d-48e3-927c-8c398e225a01
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UT20clGZEwsQDrHiXExFRx0xuH9X7ox650LdwqEAznLG9U0IfFrtxJ4iqffRRNAhlHcNy7ayVEFOS01Gj3oTeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7133
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[..]

On 19/02/2020 17:18, Sean Christopherson wrote:
> All of that being said, what about converting all of the error messages to
> pr_err_ratelimited()?  That would take the edge off this particular problem,
> wouldn't create incosistencies between error messages, and won't completely
> squash error messages in corner case scenarios on misconfigured systems.

Thanks Sean for your very detailed answer.

I've been testing the ratelimited which is far better but still prints 
12 messages.

I saw the ratelimit is on about 5 sec, I wonder if we can explicit a 
longer one for this one.

I searched around this but it doesn't seems that hacking the delay is a 
common usage.

Do you have any insights/ideas around that ?


Switching to ratelimit could be done by replacing the actual call or add 
a macro similar to  kvm_pr_unimpl() so it can be reused easily.

I can offer the patches for that.


Erwan,


