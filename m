Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4DC2C8FA0
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 22:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387445AbgK3VHP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 16:07:15 -0500
Received: from mail-bn7nam10on2075.outbound.protection.outlook.com ([40.107.92.75]:54227
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726716AbgK3VHP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 16:07:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DV7l62AR0WS2OtOJfNWgRT0eiUT/NnH+vBaZpKGULZTAgE7tzs84S69Aq0uHwLHG12iJewi+9sDjlwNekLz5913z1zZ4l2srKau62BEJtqfQMYwNX7BVyX12bwmjtwvJ0OOLTEAPBhRs0Hpa1ztWCWWQhyJSy6ODdbi4b//zzaZhbQRDSjNcvMaDSNDHO+VAYYxztVlVNiM4eo5N6sOi7uLECbTNPEL3KxcFn6fIhuP9Vf99WoeJRaq6AMoUjQ+dFPCUOQSfNHl+nE9VFE3yl+DNRZX6kD85UP2CYyG1NslWE/mGtWhWAwPyN4wnQQOQHUwZOZpAyx4v1RyVKb9G/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CjqU+9L5FXwmGkIZY9kvl25wveW4v75oQJU6GP9nXDc=;
 b=E56AMlMWVWNf+zMf4GbitkRqcq/BanxklkrE4aTmcdq7M7rZUKhKEYrt6SZvRpz6bM/5bXn+oGHMHBKDhq2dBQ1oxBZ9/mqHSkBmYCh5kYLqAbkgCat06WbyqDUsPAplIkxnVUt/F4YgxsBRUwMAyfuMIPHA2TI9fTx3iAwfbh4JW/6CAbYNAU7yYCaBXcBvaS85tFjYLN9f15PfNORaCiMUckR603FpxR53miSy7NvsD9hXuFmhxRFj3/SmnypdtO9zo1Cy4PbAooU3NDioRxluwqaNxOG1jKZXnnQwrf/+z8gtpzS4nLjBUcWJ8QYeKG0we5fnYMCo4Rvb1EPFMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CjqU+9L5FXwmGkIZY9kvl25wveW4v75oQJU6GP9nXDc=;
 b=gps4KSGdZty8z1k+Rn/QZPQxnkEN6O6MhD+kgP5YYyqlG1KxlKv2mX7jKAmPG9vat1bNi0b3oilZMdpfi9Qnd59oMTCmNgnwy+r1LMk2fTbzhfvVwNSinyr83jNx0vcezTrkP+R1557jtLmiQm+bql2+LVNgxm9D+CygQVZV/Gs=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2511.namprd12.prod.outlook.com (2603:10b6:802:23::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.23; Mon, 30 Nov
 2020 21:06:21 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3611.025; Mon, 30 Nov 2020
 21:06:21 +0000
Date:   Mon, 30 Nov 2020 21:06:15 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     cavery@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mlevitsk@redhat.com,
        vkuznets@redhat.com, wei.huang2@amd.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, jon.grimm@amd.com
Subject: Re: [PATCH v2 1/2] KVM: SVM: Move asid to vcpu_svm
Message-ID: <20201130210615.GA1459@ashkalra_ubuntu_server>
References: <aadb4690-9b2b-4801-f2fc-783cb4ae7f60@redhat.com>
 <20201129094109.32520-1-Ashish.Kalra@amd.com>
 <f27e877e-b82b-ec9e-270e-cf8f23130b0b@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f27e877e-b82b-ec9e-270e-cf8f23130b0b@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0401CA0015.namprd04.prod.outlook.com
 (2603:10b6:803:21::25) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN4PR0401CA0015.namprd04.prod.outlook.com (2603:10b6:803:21::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22 via Frontend Transport; Mon, 30 Nov 2020 21:06:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fb643af3-2f6c-4f1e-85ff-08d89573c9f2
X-MS-TrafficTypeDiagnostic: SN1PR12MB2511:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB25112E7B4AF4FADAFBDF3A8D8EF50@SN1PR12MB2511.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nqNJnMGXmPMRreHtMdv/xydROf527GUpPjukbC0g4QsUCZe3Q3KegpWbotTfnVLl/56oQjvFp3xQ+di0biT1fDCl6MO/G+WQHfytF5pa9Raic2fYJ+w/EI4uO+JVzuQ5C1+oC1wIalGZjf6+YdV1Op2NZDsNediibYvWq7PrFi5ALVc6XnEFd5p4J1xIGcXlbsIjxcd5yb3bAAtjM68C3ucmIoVdnmpn0eBymknJ23EqCNna+2EqnEHTV1n3l22vDhd5KEpYgXG+TinqUA6RUtyNptmtP3DGCIB8eAgq5461pj1RFcuphgYfTrVsovSw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(376002)(346002)(39860400002)(55016002)(2906002)(53546011)(8676002)(478600001)(956004)(6666004)(44832011)(1076003)(9686003)(8936002)(16526019)(186003)(26005)(316002)(5660300002)(52116002)(66946007)(86362001)(66556008)(66476007)(6496006)(33656002)(83380400001)(33716001)(6916009)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Kyk2AfXDx0/D2IqxG94UVFoLIV/RcLg3bM84Jm3W8NraZrzJ9GbQAr8v2wDi?=
 =?us-ascii?Q?l++JVvCjF2yJUCnaiih51AOAv+F6oGfTM3OEn1sm8b+j+Bm8dUy/k866lcsb?=
 =?us-ascii?Q?atKtR+aa/i77UMSr7NwmyLGb4GYYDPRFO0r1UEa/KHgB1ghRqSWNLNFbJ/2t?=
 =?us-ascii?Q?Ce5rzbcH0tO7aJOEtEHVj7u4NQIVH+hVRhUs0t6DeEKc9XBS8OiIo6CPEqww?=
 =?us-ascii?Q?XvCO2tgv/xMcSk+4wRsvsR+9sSshxs5XG0Pf5TxoM/fkrV5iVOTWffCCC/hH?=
 =?us-ascii?Q?zUdoX0OQJYnno/OANM8CeDdIlhk/ncIrCb32uc90KXvMaDO7phNRXNMyZDKe?=
 =?us-ascii?Q?8s2XnWczmAd/IJ3EYShXN0m0UwIIZQw5syIRSV5ZWvq/T9mm2OXXXwU0b2U8?=
 =?us-ascii?Q?4XbvFO365cdZvmvyw3/BiHgZqFwx243iitVDkMTtIlTLVorFD2UGWbGkVxwX?=
 =?us-ascii?Q?Wl8Px5CTUlPU9feJpRFyMjeabf6Pz9AZ6cPDD+G22aql8dEiFxrEYtjRcT/1?=
 =?us-ascii?Q?ULlAq/DzTpykFeLsj7dwUC2Ah85q97e76Pc2tOgkXq05qNSJ6/sUJMGy2vEY?=
 =?us-ascii?Q?pZgY6P0nVFYaaWGZGL7w2SJgr/AM6GHIDuXdQdLNJzpslbjYNyQO9NtN6pWa?=
 =?us-ascii?Q?/stZQSENb6ZXwLyg2bHR80KuM3EvCCS+i9zbud6jnnFYxy85y506Jbfgj71M?=
 =?us-ascii?Q?05LZfwknIN0qXUE9zA2wl/6JxuUGaWQ+5sBhQfgm/ITfAZlCPBSC0gHoD/sj?=
 =?us-ascii?Q?aGETjINyiQV8sUEzEepJWlVjM3EPqUU7PMZ9K97XWg4SGfo5lGrbwaeUkmlS?=
 =?us-ascii?Q?/rcQUdu7kSRHOzdpIU4ca0kV853TaitggXZqQxVqzjQqPE+f1mvq1bob1ddi?=
 =?us-ascii?Q?DKdtnPTliBgmrfmXv7a2vNcJsPzJDdtfkl+d2QHqyFCP5knzbx1GU+DJUUcy?=
 =?us-ascii?Q?QrE7fGSwoLbFvZcyzpjixDs26d+BMRNgW6T8m3WD3CE=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb643af3-2f6c-4f1e-85ff-08d89573c9f2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2020 21:06:21.6646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8cR3xKOQ2zlOP3uG8jzwUgJeHCLpHtz1g3F/dwtdQ3rMQ7t2cJbdBo6tIHX2SnogEPrkXAA9+NtN8IWYRQTjWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2511
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Paolo,

I believe one of my teammates is currently working on adding a KVM
selftest for SEV and SEV-ES.

Thanks,
Ashish

On Mon, Nov 30, 2020 at 03:41:41PM +0100, Paolo Bonzini wrote:
> On 29/11/20 10:41, Ashish Kalra wrote:
> > From: Ashish Kalra <ashish.kalra@amd.com>
> > 
> > This patch breaks SEV guests.
> > 
> > The patch stores current ASID in struct vcpu_svm and only moves it to VMCB in
> > svm_vcpu_run(), but by doing so, the ASID allocated for SEV guests and setup
> > in vmcb->control.asid by pre_sev_run() gets over-written by this ASID
> > stored in struct vcpu_svm and hence, VMRUN fails as SEV guest is bound/activated
> > on a different ASID then the one overwritten in vmcb->control.asid at VMRUN.
> > 
> > For example, asid#1 was activated for SEV guest and then vmcb->control.asid is
> > overwritten with asid#0 (svm->asid) as part of this patch in svm_vcpu_run() and
> > hence VMRUN fails.
> > 
> 
> Thanks Ashish, I've sent a patch to fix it.
> 
> Would it be possible to add a minimal SEV test to
> tools/testing/selftests/kvm?  It doesn't have to do full attestation etc.,
> if you can just write an "out" instruction using SEV_DBG_ENCRYPT and check
> that you can run it that's enough.
> 
> Paolo
> 
