Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 159CE364651
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 16:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240352AbhDSOlg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 10:41:36 -0400
Received: from mail-bn8nam11on2047.outbound.protection.outlook.com ([40.107.236.47]:25664
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231814AbhDSOle (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 10:41:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hrbrUOnQFO1iyHLQly5KuEJqHC37TQEUiGgI7+BAsKeWDV9bDXOYjv+NR346991GvaLRek3LJj3X5LUAaS9q5rA9V+1nyns/0JDKJtOLTrAqAY8yUDztn2uDLTNFYyumJQkOLbqoENmoWVCGakbH5/Qq5vyr8QXHMlUxIFJfhIRHXKFGYbXRMyX5BaJ4JV+F9UmenesALM6pSsZh4KeWu6ECzxcvPABXidzhg0pGc1Tf10c9vqLpkR4Pd1MDqncvdf3r/gXmoCTzAI9reGYh/mabtEc4WSkZw/ezoL50jL9eWAg6w2l2tGaHMgf+lXz3BNU5RqXdjhBoFUUKpWT1qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kPZegIsCzt3Igtbathhh26i2XEeAT3Xt8xFiqzAcW2o=;
 b=JcqrNbngnehHSTfnHxY/x8AHJhnxt38OienLA1XHf4aIAw9RwIXaEBxL8fz+NN6OWRt7z0cPadYF+ERXKmKKJHN1pVACZNy+v5Tz80CuB8C2w6cDo8lQg/BFU+FvRXtO+4OmAYVMxecTeTOFik2b59+dmnWWUbD59zZD7FRRvHXU/yPi9r+q9aHmUS25BDILCzfIpDurc6cB3bUhG2NOgjlDH7VYkfa0TarO650F46hanipT/GRNoPY+XCUgHaY5LHzc6LvO1cz/MXry9cGhii63FUR3mfvQ+Pybk6YbR4oYtsmT4u5DmfdIUDXm+R8g/fP7VRb+EHCfNsaa7hEtjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kPZegIsCzt3Igtbathhh26i2XEeAT3Xt8xFiqzAcW2o=;
 b=ZfMLPxIW/t5dKDNlUuqtcE83u5GBDp70gvkrLBJuiY140ZSOlLNn3DOlcMdTTkIGV0/OQSNNpbmEHYcGpxN3/XB64WWe9JWM0HAroWunKh1dOn6U+/pgNuLVFIs8S1WO9OkXKPzyobXRNcUga5if3Nl8SWGlnX4zHoTojgw6PGk=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4415.namprd12.prod.outlook.com (2603:10b6:806:70::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Mon, 19 Apr
 2021 14:41:02 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4042.024; Mon, 19 Apr 2021
 14:41:02 +0000
Date:   Mon, 19 Apr 2021 14:40:57 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Steve Rutherford <srutherford@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v13 00/12] Add AMD SEV guest live migration support
Message-ID: <20210419144057.GA1569@ashkalra_ubuntu_server>
References: <cover.1618498113.git.ashish.kalra@amd.com>
 <CABayD+dGWWha8opC7rFgNYs=bgWbohE+ngTRfKjw12fXrT+Q+g@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABayD+dGWWha8opC7rFgNYs=bgWbohE+ngTRfKjw12fXrT+Q+g@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0701CA0046.namprd07.prod.outlook.com
 (2603:10b6:803:2d::33) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN4PR0701CA0046.namprd07.prod.outlook.com (2603:10b6:803:2d::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Mon, 19 Apr 2021 14:41:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c36c3c5a-ad2c-49a1-6f1e-08d9034127ce
X-MS-TrafficTypeDiagnostic: SA0PR12MB4415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB441506C577409C29969FF1A78E499@SA0PR12MB4415.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cZkuqFzbJ5U1Hg2mHqpVjM+18sGuvrIYF/U+UDBX+eZP2EYvE8TlGzEISEuWgHkGiQcH3w9hjrKi2Vi/jEmKeN73eN4lfHjKOUJqaIN67H3z2v330jWxCD2q2INh+MeBO7yvK6khTx1VP2cBgKB+LKMqUAjkHdJHrOuZ2mzqEImQ/6/UBNk8smnqLum61ykNaWg0PObS6qHc2qDxvG9pdfDu3JF75JqubVSYJMj8mnplblVJPiAgdCWgkSp2zLSRw8cGHP0RjsBw6eG2ayLiu+m17rJXLPfKVVDRvjMR2JSKrhi2x6gKT6oOSq0IvWPEZzF15ygMkfIoxIzAUC+iqnPOen9q6A8WkEqe18+OO+Q21O8VmnwupfcbmHM4V9tW88rQYun2QSKgLOuWyAj0csVgylf365yE20Bms8V8glV07PMgPE3GwBTwer/sl9YwL/6qa28+GdRjzf2D85nc+Y0z6/01DMRG7mI3QxoEtxGcbZsvZgPf2OuEg+/c2dGj+jj1aJuBs0XL8IRM3B3U2LowZccn3u0ktAyEn/f3zdqW6jLo7Ft6W7SI1pxFW6G/JivsKnYXmCY1fxn4DTF0YVc0lhsJ/JG09qKgKnZNHMP3RcuvpEiutJJ/JuJ1nICaGJdnnboPf1m8UMnRoRU/lCSiJ+uDrttlhSlxg5fq8BSlEBlMmbH3nxVzlazbk+e+EuvUsjB/TBCYOhj6gUXuwftcEt11y6vh+6NioDlMfzA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(346002)(136003)(396003)(376002)(83380400001)(1076003)(6496006)(8936002)(52116002)(54906003)(55016002)(6666004)(38100700002)(86362001)(44832011)(9686003)(2906002)(7416002)(38350700002)(956004)(316002)(4326008)(26005)(478600001)(5660300002)(186003)(66476007)(66556008)(45080400002)(66946007)(33656002)(8676002)(33716001)(966005)(53546011)(16526019)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?by1PMoejJ2VHkQylCueA+m97fYEuczqrKIWc8YAbprpO86FC0NAcsQVJyNNa?=
 =?us-ascii?Q?rdW5DEdzH23wNurEw9YLmUAokOw0dAaMXnVBRjgann5aX2N2TM4CY48l0K1h?=
 =?us-ascii?Q?MJEA2ZmPAzBj5nf/KNF7TEjrSCqteojyavrcfFpyFzHiTLTGSj5Ci48OaXvS?=
 =?us-ascii?Q?AnD9grj65cM25DaVGdaxjdGc5fmGIXV2rZuKV6tslYtQh8Ha2NZpgh5dEXLY?=
 =?us-ascii?Q?U3BB820NOlnGPpGrS5bjO0KpFUBUMiDKCwxh8i3a1kCoDMiarf4/0EF4tB6y?=
 =?us-ascii?Q?5sSFUFZqLgvkW4ynJAA4H/h+hMCiifrwQN2bJ6/oUuzzzqlmxHw9yhWmZlcl?=
 =?us-ascii?Q?c6W6y8Wl8o+NBPPNE8NMJQlELfhXTtFuZzY/s8xboIJyx8yUs7Uv/7ggQcnu?=
 =?us-ascii?Q?Gcm1+cUUs+tP/xiTyyFpngLalX7g1V2Ps0RH1zm+si/TfF1vX5579/JYuocf?=
 =?us-ascii?Q?5Ck0cAHL7dlCJlOysQCOU1I1xBWc9mU8mNnuSHttdVVEE+LaNoSVYLsJbPY7?=
 =?us-ascii?Q?lX0kGN0A0TFmOnPiGuBKxV2DSMgmELi2ViKq8UiqtfPlCjJVLPavQpuNtMN3?=
 =?us-ascii?Q?Ihn22w4i8ioow26wJ15OboEsYxevQAmk4uFr6ki4o4FYFhUTRrljek5JY97P?=
 =?us-ascii?Q?XkC3GFgfAMYJEPEVZPfiN7ApW8x5SmlE8IfaSUlMSmnKkwO+M7Uh+SKDnST/?=
 =?us-ascii?Q?T6f4AmXk+C+5xZ705ZJiMmw3/I5fSvD1ew8Wvo3/9i9d2Ca8PMIvqPEU9XV7?=
 =?us-ascii?Q?3Lcf+SsgPb6WVpIZVcY1yBfLlOM4Rxb2qA7+DXtwRW8taySniAB91Ljj6Zqs?=
 =?us-ascii?Q?z71EkEwaxZsT+m6dQAWG9H1Wew1IGtLZ4HjVM6nl66/ppfzIN1d2B6thVbvr?=
 =?us-ascii?Q?mZUcVu5ztRg+DUSDCHdnYTJJAK354oB8eFRTmt/JoMKpuM0ECdbJQKVJ6UI9?=
 =?us-ascii?Q?V4IbSWXoYsTJjkUZBARlP+eW2pqmjsz1BxReySM8itiKjI79VWHIKsGb2Upz?=
 =?us-ascii?Q?0PGX+wV8cKtZ3QCzNFku1p59wy0F7EDznTysPerJVKAdY3bkYyJqANfUdALI?=
 =?us-ascii?Q?kRN7iPv050CekvrU1i5xKXgFe80wFCVRuqn48VaY1sWB6XyT27F+EfbATY36?=
 =?us-ascii?Q?QEu4f8famnZPdDQm1NSmUMS+RxQKoCW+jwlk9V7qHOP7vEC57x9WP0ddOTyD?=
 =?us-ascii?Q?vS05YfD+PlQBt49twr5r5tiJX1954eYhcm5/f629P922q+4TrjUPbCpMlJmH?=
 =?us-ascii?Q?Dcr1NNP0ufFlIFCeldCj2dl7lM5E3SN9WCHTSAhzrdeSGTQjvBDrzLJVbH8e?=
 =?us-ascii?Q?m/+Kp/OX1pgQITyyuf8Y4wAM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c36c3c5a-ad2c-49a1-6f1e-08d9034127ce
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2021 14:41:02.7992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dq8Pl7G9lLb1Y7qO7bbORiXa08HQiqhzJThWJD4/dQyNkwpbTFNdyV5AjY8vx4XwLEaWp0kiFRb6sdEfCl0Gkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4415
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 16, 2021 at 02:43:48PM -0700, Steve Rutherford wrote:
> On Thu, Apr 15, 2021 at 8:52 AM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> >
> > From: Ashish Kalra <ashish.kalra@amd.com>
> >
> > The series add support for AMD SEV guest live migration commands. To protect the
> > confidentiality of an SEV protected guest memory while in transit we need to
> > use the SEV commands defined in SEV API spec [1].
> >
> > SEV guest VMs have the concept of private and shared memory. Private memory
> > is encrypted with the guest-specific key, while shared memory may be encrypted
> > with hypervisor key. The commands provided by the SEV FW are meant to be used
> > for the private memory only. The patch series introduces a new hypercall.
> > The guest OS can use this hypercall to notify the page encryption status.
> > If the page is encrypted with guest specific-key then we use SEV command during
> > the migration. If page is not encrypted then fallback to default.
> >
> > The patch uses the KVM_EXIT_HYPERCALL exitcode and hypercall to
> > userspace exit functionality as a common interface from the guest back to the
> > VMM and passing on the guest shared/unencrypted page information to the
> > userspace VMM/Qemu. Qemu can consult this information during migration to know
> > whether the page is encrypted.
> >
> > This section descibes how the SEV live migration feature is negotiated
> > between the host and guest, the host indicates this feature support via
> > KVM_FEATURE_CPUID. The guest firmware (OVMF) detects this feature and
> > sets a UEFI enviroment variable indicating OVMF support for live
> > migration, the guest kernel also detects the host support for this
> > feature via cpuid and in case of an EFI boot verifies if OVMF also
> > supports this feature by getting the UEFI enviroment variable and if it
> > set then enables live migration feature on host by writing to a custom
> > MSR, if not booted under EFI, then it simply enables the feature by
> > again writing to the custom MSR. The MSR is also handled by the
> > userspace VMM/Qemu.
> >
> > A branch containing these patches is available here:
> > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2FAMDESE%2Flinux%2Ftree%2Fsev-migration-v13&amp;data=04%7C01%7CAshish.Kalra%40amd.com%7C7bee6d5c907b46d0998508d90120ce2d%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637542063133830260%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=FkKrciL41GDNyNDqrPMVblRa%2FaReogW4OzhbYaSYs04%3D&amp;reserved=0
> >
> > [1] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fdeveloper.amd.com%2Fwp-content%2Fresources%2F55766.PDF&amp;data=04%7C01%7CAshish.Kalra%40amd.com%7C7bee6d5c907b46d0998508d90120ce2d%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637542063133830260%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=%2FLFBR9ean0acMmR8WTLUHZsAynYPRAa7%2FeZEVVdpCo8%3D&amp;reserved=0
> >
> > Changes since v12:
> > - Reset page encryption status during early boot instead of just
> >   before the kexec to avoid SMP races during kvm_pv_guest_cpu_reboot().
> 
> Does this series need to disable the MSR during kvm_pv_guest_cpu_reboot()?
> 

Yes, i think that will make sense, it will be similar to the first time
VM boot where the MSR will be disabled till it is enabled at early
kernel boot. I will add this to the current patch series.

Thanks,
Ashish

> I _think_ going into blackout during the window after restart, but
> before the MSR is explicitly reenabled, would cause corruption. The
> historical shared pages could be re-allocated as non-shared pages
> during restart.
> 
> Steve
