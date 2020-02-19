Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7320D16436E
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 12:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgBSLds (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 06:33:48 -0500
Received: from mail-db8eur05on2113.outbound.protection.outlook.com ([40.107.20.113]:32576
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726270AbgBSLds (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 06:33:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Byeniih9piagA7RrjbZnDH35RaPKNR2D5X5i4kvSUlvRQGgFAdT/4kgso+PSYRUOG8/l3I24ALDWZLveH1igxpoAwqLn+mSeXPEqcagd15nNHj4XRTbdAdnq5Q6u9Pa6SuH6nukyQ84e88VL+oR3W9KgoBioUhGwANmpjYcOfkk9XPmPs3IjG2N+k5z+lBtZvB/em7geE306XeUJ7GoOKaZAaWMB8bEdNx41Hbrs11THdRN2RblaEoCqYXlsBc+0rOXHTMvp0nXLjGF57SuL96Eiyk9Ybdn8rFg40ENKw9gellJSw5xUh3zksd8m3UwRLCGf7AEufBMdL5lB9w2Q3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OhORqGGEeidanHLd2dJLxLKztCPUKuB8xsZZx046zwA=;
 b=lo4praxBC2q8t4DGAlIwKt6gjk9U9+0UR6RvK+ztom9tg39nNPbSGcy8oyeN5Bo3oOIwScWHQyuogr27dLrj/Td86aTQ4A2vP11DhwJm4oB60JkeRbZXCEPE/59DU1+wQz5Dz7L6ULU3+nFuECsJaa9JnB5zgO4oWfk3M+usTEFKjPSnPU6z005A9QpGmtF/JxuR6TM/CPYaETR/K1qfrC6LFv5ov5RwKPgnUlhFElRIva/WPB2pJFK0vFxCg7zV9koTr+Xzx9IIaUuM6VRpOugU54RtFWjfhhjY3k5JirmkcKRf0ZQw5+1PBJTjApzZkrAALuHeFxGrDjoAcAihBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=criteo.com; dmarc=pass action=none header.from=criteo.com;
 dkim=pass header.d=criteo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=criteo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OhORqGGEeidanHLd2dJLxLKztCPUKuB8xsZZx046zwA=;
 b=H9nusnNdEECpDvggdu5dChIK1yiyAoH54Ozg06e2VVieOFI4j2CLay3dMRE750vRwSleTY836gKovZNJfTn8S5Zro/JIzmjV8HJ3bHneOay+he135VIEmaiG6cTytvH8eLFLi8Bo1fcY8a6s45d9nKIqTpMvGT2qXLczwyB9G48=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=e.velu@criteo.com; 
Received: from VI1PR04MB4926.eurprd04.prod.outlook.com (20.177.48.80) by
 VI1PR04MB4094.eurprd04.prod.outlook.com (52.133.13.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Wed, 19 Feb 2020 11:33:44 +0000
Received: from VI1PR04MB4926.eurprd04.prod.outlook.com
 ([fe80::99f4:5892:158f:5ae4]) by VI1PR04MB4926.eurprd04.prod.outlook.com
 ([fe80::99f4:5892:158f:5ae4%5]) with mapi id 15.20.2729.032; Wed, 19 Feb 2020
 11:33:44 +0000
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
Message-ID: <416e20b6-8f21-5949-bf51-f02603793b49@criteo.com>
Date:   Wed, 19 Feb 2020 12:32:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <91db305a-1d81-61a6-125b-3094e75b4b3e@criteo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: LO2P265CA0145.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::13) To VI1PR04MB4926.eurprd04.prod.outlook.com
 (2603:10a6:803:51::16)
MIME-Version: 1.0
Received: from [192.168.4.193] (91.199.242.236) by LO2P265CA0145.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:9::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.17 via Frontend Transport; Wed, 19 Feb 2020 11:33:44 +0000
X-Originating-IP: [91.199.242.236]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1516dba4-aa3f-4a97-4845-08d7b52f93e1
X-MS-TrafficTypeDiagnostic: VI1PR04MB4094:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4094D424B71DB08DF0CC14E8F2100@VI1PR04MB4094.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0318501FAE
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(189003)(199004)(956004)(81166006)(81156014)(53546011)(2906002)(8676002)(8936002)(86362001)(52116002)(5660300002)(26005)(36756003)(31686004)(31696002)(16526019)(7416002)(186003)(54906003)(16576012)(6916009)(2616005)(4326008)(66946007)(6486002)(66476007)(498600001)(558084003)(966005)(66556008)(6666004);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR04MB4094;H:VI1PR04MB4926.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: criteo.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qTRnLo2lXG7Tur0oBfXUYQXt8iOHk5Pfhh2G2J82yEH83n1udIrOF+jP42kk1icSIp0EoFHyELv0DPclDlXKj+2Z+OP7Ocnv5llYVi0zMVy/p1/hNGkEcwCs27hrTQk8J6m4NAvHvNyi/3ssb/rpLSRHP5gclV7sWYu3hp574Bm60+owELo1Oor0vvqKDrexRzMa7D178ClYXVbc4xDBeoKr3FNRxv+/wwqgkASQUzvxQYisR22zo4/vdWDq18JySmAbzN+LYseQgAj/l/2UkV4FHINL47S0rw0aj7ofRXClHk2j7X8V6AjHT38NZteE98rcMZemXaSWsHk+ptevcOyyNuvY7NEudumA2ndHJzuyT/dRfbRiV3nV9iSI9rgS2cJrB6/WXubKD/Gc5yUZRzUDbzuBY9sgmKectVhbxjhas+dGJl8esjspVLy6mpnpj3QluQ24CVDxsTBDJv5SKYqN5Hda6xW79gzhW0F+dPiKZnta15dE6P7AMEsuZnSu8D8BqlH9Huh2gXr9PTpjLA==
X-MS-Exchange-AntiSpam-MessageData: fsE2UttsAyv9jIytySt8OjLszC8o7e+I3/sc9LGOOzw5FrZbF15hhGCh7tVg2K3udsko1SzWfRncgKSFtclRoyqxk/PdkDiUlzxim5fWIZQKmt3mhidijk93NVzEXRkXQtWlsUFk3aD8J0GLXXplAw==
X-OriginatorOrg: criteo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1516dba4-aa3f-4a97-4845-08d7b52f93e1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2020 11:33:44.7268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2a35d8fd-574d-48e3-927c-8c398e225a01
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RBZ7RAVCRpLEeUNHulTIAhldZiuUvyX4NVAVq1HtcoXTmIOv96W/OpjFvHEB1F8ElPGaZ7u8dfZBswVn47DO0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4094
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/02/2020 12:19, Erwan Velu wrote:
[...]
> - contacting the udev people to see the rational & fix it too : I'll 
> do that 

I created https://github.com/systemd/systemd/issues/14906, if some want 
to participate/follow the discussions with systemd.

Erwan,

