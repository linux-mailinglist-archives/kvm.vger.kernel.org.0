Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E94B15CE12
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 23:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgBMW2f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 17:28:35 -0500
Received: from mail-mw2nam12on2054.outbound.protection.outlook.com ([40.107.244.54]:6194
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726780AbgBMW2e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 17:28:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n2KVNgEVtN2uKuS/Lg6kdN9Bxd+qBkNVkYwjDBSd6Yy79IPPiD7eIOs2t9i0RqafUMQS4aGNXYIRAAGaKgehdtawdM1fGEOUJ7u1O07jX3ssHLz+nGhex7T7AVoib63rrjN3zCAscf0wtJ/gclGH+iIv69BZlVPsUkp0aWfAAZvfppAA4GUqG6jkMsb8IUtcqydyLO/+MB5hE9dA2uqjhMwgfGLkJjR/gOHZdrmF9CWPotso1B54LA2Bafw3u+HP2zeUWwOftty5jGWgX4Llxxdz8+aecZWr6G5rRCzP8yomEVysuZMV3Q7BtcTWGOi9xBG62LKYnz/u2EX/i22K3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y+NKkAFnf1wCFqWpZ4FwDbTT+ee+Tq7RQ+oCptIR2Z8=;
 b=gxhUeEyPl82niyADyxEGLRiu7+5QucyTeUSVPROScaKj8nqHQqfomK4OHHr5CeuKx1RapW0x2MXubWSw0YpIn9Q5ifFT8IQkJtYj0ALBm6giLWy3+JIOgrMAuCdSA+LjRC6px2kKBeHuC0rzng0KmnDu9HbBCyApKh25D/BjdfxX5UchhClJJ8IDTbIlIRCEw0dxVGjswaSdlV0C2GOxK5FHRwTBtT8C1Qh3r7bcGXRIJjHMebO/Gi9jJNaGR5w1Zdi4z4XOKhnz2NS0UaZM1Q/yg5u/T9X3dqkc3NtsRtSlAvcqkLXpJr01M+Xsz0WwPmdcTauJS10yOGPc9xSktw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y+NKkAFnf1wCFqWpZ4FwDbTT+ee+Tq7RQ+oCptIR2Z8=;
 b=TIDVisVY01nPuaUrjQkUGLGe5cX0487G3+ds9d9MGuFqIAtH6b1LeUF6q6LdQIkC7lnUfdr3qfNip4LcYpZIEXuxF5lBYJYCHaheeNnrkzR65ref8i6OIWdiMPx5Qp4dY1T/pTg1Pe/jxWUCGnk5eoJ9WcEGiZhJ7wjGRJJf7hU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from SN1PR12MB2528.namprd12.prod.outlook.com (52.132.196.33) by
 SN1PR12MB2589.namprd12.prod.outlook.com (52.132.198.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Thu, 13 Feb 2020 22:28:32 +0000
Received: from SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::fd48:9921:dd63:c6e1]) by SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::fd48:9921:dd63:c6e1%7]) with mapi id 15.20.2707.030; Thu, 13 Feb 2020
 22:28:32 +0000
Date:   Thu, 13 Feb 2020 22:28:25 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/12] mm: x86: Invoke hypercall when page encryption
 status is changed
Message-ID: <20200213222825.GA8784@ashkalra_ubuntu_server>
References: <cover.1581555616.git.ashish.kalra@amd.com>
 <a22c5b534fa035b23e549669fd5ac617b6031158.1581555616.git.ashish.kalra@amd.com>
 <CALCETrX6Oo00NXn2QfR=eOKD9wvWiov_=WBRwb7V266=hJ2Duw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrX6Oo00NXn2QfR=eOKD9wvWiov_=WBRwb7V266=hJ2Duw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: DM3PR11CA0017.namprd11.prod.outlook.com
 (2603:10b6:0:54::27) To SN1PR12MB2528.namprd12.prod.outlook.com
 (2603:10b6:802:28::33)
MIME-Version: 1.0
Received: from ashkalra_ubuntu_server (165.204.77.1) by DM3PR11CA0017.namprd11.prod.outlook.com (2603:10b6:0:54::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.24 via Frontend Transport; Thu, 13 Feb 2020 22:28:31 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 382e77ec-4c28-4e2a-4aba-08d7b0d40eba
X-MS-TrafficTypeDiagnostic: SN1PR12MB2589:|SN1PR12MB2589:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB258980DDAA18475FAB0FD4438E1A0@SN1PR12MB2589.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 031257FE13
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(136003)(396003)(39860400002)(189003)(199004)(316002)(6916009)(33656002)(2906002)(33716001)(956004)(86362001)(8676002)(5660300002)(7416002)(54906003)(81156014)(81166006)(44832011)(8936002)(52116002)(53546011)(6496006)(478600001)(26005)(186003)(16526019)(66556008)(66476007)(66946007)(6666004)(4326008)(9686003)(1076003)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN1PR12MB2589;H:SN1PR12MB2528.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fLY35JEOJ/oj2l1SKvQ6TdzZ2eSnCpZMwWXyfxCX6ZTHcjFnFw9o1zlOLlBxJDmyfMs3ps5KZgHfwmdItsJz+ObBcpGBmF/0MQBn83NPMe2HxoxMtvHz/hgi+oSbPIZYA5ssZtcmV4/5dk4PBVGUY8XX0Hz6YB5H9JCzz79zLf7nX8BMwgB4v5us0uKS77/4MApvF9Z1qaw38b/N6Qk5I8iQzVDtw3n61gluz1CcyzOjWLJYAHXt8xWvlkzQRnLdxB1xV1K60sp1FcbO6gIO7HToXRyepmiMGRXcZYfHtK5mix0lZwkXxpjc5ZfSVMWAQZMFa5QKjw2pCamJTB/iKeRctgmpi+PlrxE4BwtMTROL8gDW+Bi5Hz7QsRwFNu3rGg1/jNFgEh/BbOcYuEi/3t1rfTb9jS4N9FpYVo08oBkJziGkzIdloTmfBFsNZQib
X-MS-Exchange-AntiSpam-MessageData: ZxbWk4lLAsy/LsEvo8BG75VYuONXJMPK6tM+xfPsK8spqOOWKxlLIV/9G0QxSFb079I9+OJ2XP6lhDvtGQ17IoaT9gTITOZG0zqJiNax1ZBSbJln/Uo5Y8S7rRa/JiyfYjjAp+3B8LiN5tw/vf8CVw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 382e77ec-4c28-4e2a-4aba-08d7b0d40eba
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2020 22:28:32.6657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +4ImK4TBmDmKPo0G+SmhxvqNiHU43b/1wxSJYL5HXz3MvZzMP++4HfaurVZA0pa/Dj3FWBswdAF27VAdCihjLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2589
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 12, 2020 at 09:42:02PM -0800, Andy Lutomirski wrote:
>> On Wed, Feb 12, 2020 at 5:18 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>> >
>> > From: Brijesh Singh <brijesh.singh@amd.com>
> >
> > Invoke a hypercall when a memory region is changed from encrypted ->
> > decrypted and vice versa. Hypervisor need to know the page encryption
> > status during the guest migration.
>> 
>> What happens if the guest memory status doesn't match what the
>> hypervisor thinks it is?  What happens if the guest gets migrated
>> between the hypercall and the associated flushes?

This is basically same as the dirty page tracking and logging being done
during Live Migration. As with dirty page tracking and logging we
maintain a page encryption bitmap in the kernel which keeps tracks of
guest's page encrypted/decrypted state changes and this bitmap is
sync'ed regularly from kernel to qemu and also during the live migration
process, therefore any dirty pages whose encryption status will change
during migration, should also have their page status updated when the
page encryption bitmap is sync'ed. 

Also i think that when the amount of dirty pages reach a low threshold,
QEMU stops the source VM and then transfers all the remaining dirty
pages, so at that point, there will also be a final sync of the page
encryption bitmap, there won't be any hypercalls after this as the
source VM has been stopped and the remaining VM state gets transferred.

Thanks,
Ashish
