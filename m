Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35244352BF
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 20:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhJTSif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 14:38:35 -0400
Received: from mail-dm6nam08on2071.outbound.protection.outlook.com ([40.107.102.71]:39368
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230076AbhJTSie (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 14:38:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jXdm2LdA7s7N5DlbxIbdqjPPyGtNTRwYxmWcDM4gkmWFXUaM52jYhQmgiwcmr/b/HjDlw1Bv+6eDruEJUvKSgyJvr8nrAsAzzd762WwNZ/Zg1irG72svFh4AjJilebMjDTgaJz5z/T6D4WFOjRuJYoLSd9gKG2NKX12F5FFMt9fA8eakJIPGzXlld0xptOKRBn+/r2VcuY1UMHrIfiNm/MXDzJGFDaS9OEzzi1tMn9LEP8EP1WFVG7kOh4OpGJMaLjaR8bC6obM6B/YsyZgwv9qiWdPooJUrpenehO1vRgIYkxU3WzhDvy5pTmqdDmatsJt4DzabM4ZMy9R+zzNvpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2dPpTbpwA93qUaaz/xyyv0u9FmeW9sMASkSDdSjb9xg=;
 b=jELX7MH31L3Vt3mRB0ShAw1BL1b/kBqbVeHURYE7xKBj0+IRhWJ6rxIpOlz4FtvZy5CvkbEBa6f0d8BIbVwDXLSWp3vjvapLiE714fTZAHPD0jwWqHjX87fcaGjn8ZzfrJA/1P5BqZWhDQEM38G8da6eHBH3+aMqtiDhbca8bwZctNBBJuSNbVLSMix3kPRqtdqra7VDskTgTt9rDO92kHcgegXxncGdBk+ODd2KULzdFvYpt0JweODUtx89cYiPBL8V65zkcpfJe+AMMGsEFtQU0UFaBCm8kxjO8PjjBn3+UBv0K899U89+lQWP+E3AVBPunHbLA5WfOwcMjqxSXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2dPpTbpwA93qUaaz/xyyv0u9FmeW9sMASkSDdSjb9xg=;
 b=YmeCobADVS/H6npT8gsM/Ha5sGK8hj3kTtJR/ABlZ7lsPfp3oWN8f5j7RGjXveu1KVY/9tCJYl6cAKQecT4jxV5WJK893UkG1EVLguSTeSrF5G4IvZVhS9lQr4yWRGONIM9TbbtdggGGiZfUREqDYQgcoYiATfOEBnoWCOYivi8=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5232.namprd12.prod.outlook.com (2603:10b6:5:39c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Wed, 20 Oct
 2021 18:36:18 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9%7]) with mapi id 15.20.4628.016; Wed, 20 Oct 2021
 18:36:18 +0000
Subject: Re: [PATCH v5 4/6] KVM: SVM: Add support to handle AP reset MSR
 protocol
To:     Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
References: <20211020124416.24523-1-joro@8bytes.org>
 <20211020124416.24523-5-joro@8bytes.org> <YXBUlYll8JDjH/Wd@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <2ae35ebd-aaed-a3df-c74e-5a3be378b8af@amd.com>
Date:   Wed, 20 Oct 2021 13:36:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YXBUlYll8JDjH/Wd@google.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0093.namprd03.prod.outlook.com
 (2603:10b6:610:cd::8) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from [10.236.30.241] (165.204.77.1) by CH0PR03CA0093.namprd03.prod.outlook.com (2603:10b6:610:cd::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15 via Frontend Transport; Wed, 20 Oct 2021 18:36:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a190dd46-ca02-4eda-c53f-08d993f8815a
X-MS-TrafficTypeDiagnostic: DM4PR12MB5232:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB523255C96065AD7B7FF4C240ECBE9@DM4PR12MB5232.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q9MWk9VVCW1wc1pZD3hyJ3KvA/ySxpUhijnSAz6I8lpIt2/upLAQhr0PzjrpVZ6ti/y7xFEwCeWJe/CIzJOoxTgHpE4nKLFvc16siMd3MfhmLkPlIe8BjsvmwvkPfTL4JdEQW24FnuXG71y+6mWV363pSdoVDuMTtO2eFNm2Ufv8puR6zYWOxf6sZh0zZiBausHiefV4YyBgSQNkXvonR3ecqRChtgK8+kbcfZTlvY0kLgILjWsh7awS4P1iqagiunPeo1PcDZnhky/2rVX8dqnL7ohINg5nC07d4FbDPhU4cPJzeQKq0lnFXQ0vUt6li1Zk//zlHwtK3aZ+K5e6n10gNG8S11Jqhc3EuMtJetPTH7eJjXUP7CWTKnRgahw678aKlnl2ooMehW4eo/AWjeRSM42Ow73nzQZ2Pp3H/NbjRn5jvEXapEwUc5FcviieizQFcjawK4wAd8Q9zPwn1o+em7V7nb4UdgAjguD0s8aWC2oS7rfQuT38Q6X7q5NIP37NUpcidwXR3hyUKCeSwltah4J7A2zls4N14Ght9saM4vsrDZhsTz9HZqF4hvkWjpMyQ2jUsono8am2OCXiyDg9uEMffs+waMrUiqcqamg3S/anwziDq3wZbBSWtY6qEUyozUQKW1DjY/TAQl5fkEbPgdsomfQYtjO7YnH8V1coTaw10rEmOkZAKe3013G0jdYDlAKVvu2EfokDyzHn5aSY1rLG/3l1ip5hmXaWUkPdrHQ0c5HryqnabfBfW5B7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(7416002)(36756003)(83380400001)(31696002)(86362001)(26005)(53546011)(4744005)(186003)(4326008)(38100700002)(956004)(2616005)(5660300002)(508600001)(2906002)(31686004)(66476007)(54906003)(66946007)(66556008)(316002)(110136005)(16576012)(8936002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?Windows-1252?Q?J/n4VU0iPuJGCLBuaGM0iipc0kGPVxMGZm7L0RuAtrG7zJe9Ua6exnF6?=
 =?Windows-1252?Q?hdQUbJFR0IhMkW8n8K4pqaGnlNb4sAHsBe36cBsRAU4Y/D+c1v6uQ7H2?=
 =?Windows-1252?Q?DTiiAU/hGdxIoAvWJ1ep4ICZ7P/4z1pZVpngZ++81Uy38jNAsLd9B2A+?=
 =?Windows-1252?Q?ULI5a83no6zETOfpctc3AhVxicfnR8hqmaVKPd7rdxlwwtZvdftJ4QV7?=
 =?Windows-1252?Q?4tZolalCLsX7fe6JayXn4nnFV5pN6XVPA7wuqdvOIvQPDs7X7AOTwChD?=
 =?Windows-1252?Q?zVVHEnd2A/L1KUHUPOfFrPjragiEmjvTmcDm33FsBAghHScsCdB/PP2w?=
 =?Windows-1252?Q?IbLWn3Z0QGyXXxk6JSOQiNiHkJlbM7jYBXR/5GVtBcN8IjzFG2cszDYY?=
 =?Windows-1252?Q?C4dFLeQ+oYwM+OTgJnUCncUEwGH5fark6OTHL3BIpeSTTSvwYyfCPhB3?=
 =?Windows-1252?Q?vXlEg7rR7mlnaaKNXpo0dTSWrRApdJJL6A1WjdvdYzR9hZT1TQX8h9O5?=
 =?Windows-1252?Q?Gd2AX3KfUr5zMG1WYzDajZv2Qv0+z9bFZxVzeRm2dUD/+QopJawQuPCG?=
 =?Windows-1252?Q?DUEGqDAvBgqmJx5RKblia0tVUwZXK3XDD6Fl2ieYJsQvK47hKoJD2/Ht?=
 =?Windows-1252?Q?X1RGB0aPptrQT8J/Kwg4pevgdqqjchocJyiN0phLdlL9YJfQgIRkObTw?=
 =?Windows-1252?Q?bx06asGvY9h+KByY3VXB6LJNJEx+1hrxmy1tUyksKTgACBgWBdYQqoQA?=
 =?Windows-1252?Q?TzllerWJqzvdNGlvxJe5waxTSftpQh8EO7+HyGNNd4/g4/XvwfjUzO52?=
 =?Windows-1252?Q?FV74DZsgE/anonZHdZJp++x1OOf7o9+h0iUGD9orEkvt53oBsvWwered?=
 =?Windows-1252?Q?RDvm3HB6We3Ls6ZAJcLbLkWMbWY6ORNgDp4QWRbkGI/G2VFvz4Sd66Hq?=
 =?Windows-1252?Q?X4I8T6HS/vBm7VKJWA+M3YvB6XghJW3sSLQVmn992ZlOfwfG82g05KAs?=
 =?Windows-1252?Q?w9bFTFJ9px8o0ZOfO4hH2LAvDRmJPlG9e0M51+oEM3+lxvEnwE3lOeIZ?=
 =?Windows-1252?Q?jfcy67OZTF2POzsb9dcluK3NhbcOqb9MrnH9yYCvCsswAOWsBd/pfcwr?=
 =?Windows-1252?Q?FNTxjmEzxHSU+yp2OA7gYAYwFVDd3d2jMbo7BcSZxWQ1Phc+j5LDfIXO?=
 =?Windows-1252?Q?TXyHnlVD7wIG62yMjZTE/6J0w5mbKnyLpd3A0naujJxxE1Z46E5bcdx4?=
 =?Windows-1252?Q?NA3ojVOQ3ePz/5pn0GSNUGOJvdbKFlKl5UOaasMg3m72c4Nny29L10qC?=
 =?Windows-1252?Q?JMejIG2HqDG3D3FFM++kfsiEyZxp6b7M97KJaKlqwvz/4lTgV4aLFfvD?=
 =?Windows-1252?Q?bDlqUrixfr1Q8zXHNuMfFQ9M/wqPJq5iSYDINb9viIWJt/VFHDYTvTwO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a190dd46-ca02-4eda-c53f-08d993f8815a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 18:36:18.2441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tlendack@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5232
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/20/21 12:40 PM, Sean Christopherson wrote:
> On Wed, Oct 20, 2021, Joerg Roedel wrote:
> 
> Tying into above, handling this in SIPI is flawed.  For example, if the guest
> does INIT-SIPI-SIPI without a reset hold, KVM would incorrect set sw_exit_info_2
> on the SIPI.  Because this mess requires an INIT, KVM has lost track of whether
> the guest was in KVM_MP_STATE_AP_RESET_HOLD and thus can't know if the SIPI
> arrived after a reset hold.  Looking at KVM, IIUC, this bug is why the hack
> "received_first_sipi" exists.

The received_first_sipi is because the APs have to be started the very 
first time in the traditional way. The AP can't issue an AP reset hold if 
it hasn't started to begin with in which case there would be no GHCB mapped.

After the check to see if the  GHCB is mapped was added to 
sev_vcpu_deliver_sipi_vector(), the "received_first_sipi" could probably 
have been deleted at that point.

Thanks,
Tom

