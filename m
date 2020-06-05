Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C781EFD72
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 18:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgFEQVU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 12:21:20 -0400
Received: from mail-dm6nam10on2059.outbound.protection.outlook.com ([40.107.93.59]:34195
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726068AbgFEQVU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 12:21:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FRkuGALrkLcwenzDQXN55Eq9WJj8jJCObogVSB5jAOv+zD2oA6Q817V7YUNPMj/zQPx1jxhNTdEPwA6OlEcOcDjtt2ZLOO3fAuk5L6eiiiQKIMH1jIef2wS2oh8IUOjVTk3cRN32+3EKHrqaz3De7ST9rjAHY4O/Yr2vvZbH8nn9oFHwn6uoQcz6akahNEs5xtyFOaMWLPcDC5TXWYkVOg4HMVp1mA8n9/sgComwFhF9alOcZi+3s5vCoLwkqYYo2Mf06bTTwAR8lO2DSPVj4FN12jGA51zdIfTEtCOGCBVYiBGEi87vSyFBk7xOHKLZZ6vAbCflJ+sWsp3blAwBgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ARFUTZWyiCTEJr7Q4VrJi1zJFH/5bPou8dDcLbg5z1Y=;
 b=VX7937h4UqbWMPbz6zQg6W2Uh+loM3x7T5/1n1Nuil7sliCy67zbI8tF5QZBm/zRz+zlvNhn3taiquJZl1/3wMGBvEb0FRJDfbjJ1LVDkoC9j1D4yWJICWsWAgMqSlBX+UeHlSIc+5NVVQgcM2E/2KDreQ+4UaHNnUC1qYJX63tNRIAWodJlvtVqnfiO+wuQm74u7AErCCQymMdq7rKMDhyPXecUJ8GV5hiu7P5JaT6Mp7RY1HlSdSV3OAmyZhwujfNBlyDBix24P3N0WGZoFlMiFh0mockq/En6CZWVg5i9Q6mfDt1cg4aO0+q1Cxsm1bNOVN9XF5yhNKE0gt5ePQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ARFUTZWyiCTEJr7Q4VrJi1zJFH/5bPou8dDcLbg5z1Y=;
 b=VTeUIwQ1jpZSCfhr1g0q635lrCOVJG3yk+7rlGC4he9LIenHMe3L1x301UBtMLTNDpG0GfL0uNHiA4iXgUOej4boyDmnhdnC8fBVm+wXSIT4G51+vWblhmZEgPgIrI3dR5prpvE0V2qY691xkmvdrCuwoITyuSgpzvDdqWaBesc=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from MW2PR12MB2556.namprd12.prod.outlook.com (2603:10b6:907:a::11)
 by MW2PR12MB2362.namprd12.prod.outlook.com (2603:10b6:907:e::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.20; Fri, 5 Jun
 2020 16:21:16 +0000
Received: from MW2PR12MB2556.namprd12.prod.outlook.com
 ([fe80::9c8e:f3d8:eb8a:255c]) by MW2PR12MB2556.namprd12.prod.outlook.com
 ([fe80::9c8e:f3d8:eb8a:255c%6]) with mapi id 15.20.3066.019; Fri, 5 Jun 2020
 16:21:16 +0000
Subject: RE: [PATCH v13 1/5] i386: Add support for CPUID_8000_001E for AMD
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     "mst@redhat.com" <mst@redhat.com>,
        "marcel.apfelbaum@gmail.com" <marcel.apfelbaum@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rth@twiddle.net" <rth@twiddle.net>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kash@tripleback.net" <kash@tripleback.net>,
        "geoff@hostfission.com" <geoff@hostfission.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
References: <1528498581-131037-1-git-send-email-babu.moger@amd.com>
 <1528498581-131037-2-git-send-email-babu.moger@amd.com>
 <20200602175212.GH577771@habkost.net>
 <b6e22360-5fa0-9ade-624d-9de1f76b360b@amd.com>
 <20200604205400.GE2366737@habkost.net>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <fcef7498-eea5-616e-6b92-f764884e8b2c@amd.com>
Date:   Fri, 5 Jun 2020 11:21:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200604205400.GE2366737@habkost.net>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0801CA0024.namprd08.prod.outlook.com
 (2603:10b6:803:29::34) To MW2PR12MB2556.namprd12.prod.outlook.com
 (2603:10b6:907:a::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.79] (165.204.77.1) by SN4PR0801CA0024.namprd08.prod.outlook.com (2603:10b6:803:29::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18 via Frontend Transport; Fri, 5 Jun 2020 16:21:15 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ab2a8eaa-6363-48f0-1820-08d8096c78e4
X-MS-TrafficTypeDiagnostic: MW2PR12MB2362:
X-Microsoft-Antispam-PRVS: <MW2PR12MB23622966ACC0A9028D572F0295860@MW2PR12MB2362.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0425A67DEF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6UEVGKZaYQTJAe5XcZ4+RS5ItOsUJS3ZQX5K0zH2Ajo9PYXAHPs5S70NXUsKPJB9T1XkeCPpxcIqGyTDU6VBQCKKm7c/2aToU1jRnglfYk3MZZ19IGesaedQq0IBTRg8XwaU8zF/8AX3NbsCjhnVfDxjesA6ROqBP7JYNOVddKaCDipchiHrolexGMVnSHcvtTXy4jKRafEEkA5erbPnXQ8tYfViclc/+py2+9Pf3gZNmCzKC40dcXwgq2USWuseOnw22rUyarDEI9vN1/JnyHdejcudtve/xlzSfL+RLywSf6ZUbo5deD/Fpd8ras1YeswsUY9IgK23kqIFvpUY/O9JOjHEh6+QnKqNM+GdrMUbyyya7ILsU/Ceg7nu1UpHNr8VmOs2eiUuUonD4X7q5PQZhSsO5zrovyg4UrALtA2A0ts4j9T8CWcUVtuoV/3eFEWV7nR33IFRsRyRrfSeDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB2556.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(136003)(396003)(346002)(366004)(44832011)(52116002)(5660300002)(31686004)(31696002)(6916009)(86362001)(4326008)(36756003)(6486002)(53546011)(7416002)(83380400001)(16526019)(186003)(956004)(2616005)(26005)(66556008)(66476007)(66946007)(2906002)(54906003)(316002)(478600001)(16576012)(45080400002)(8936002)(83080400001)(8676002)(966005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 4l9hD1fxxYiRRo6TjdCw1zJyaGm22ZiWhzA7QPcjAFVhDgLz/djaoaZY2uuFpQbFuc5CpXKABYBpAHaVKCFw3dIJ1sefmSaWOdM9HGLEkgOk/gt5BqOKBbLxZxlbpml/cc511Mwbf1N2EdLLhNby6VEncjPQ1HXxJmfiwtdkfWZqJsBcaZr4mbB+MyI9j/PZmHev2lLDtgRM0k6buQMRkSA4ppYLblA9cTuxRLetqkB3WF8qEUt183zG2Ef1Wr2DK+kdu8KldXLEgr2Y7Mhze7Wap1/8DFgvymKfb05Y/g3R8GfWaql3jktlp2oQtnFjHv6rNK7boUEhDXoCTF73BJy1W+IR5uZhYqtN52LoOlVp9g/Hv8k350dOwJ3VWSWZH5oQ9StGVNcgjn0yrVckyQxkyXkAxrS7hTyblZ6Tozjuu6Z/mSZcbjrlhovWGOGGSIIUS02kM4tEa2mjO18Er1DIT2bNE/7Lzp9QC6qgCIk=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab2a8eaa-6363-48f0-1820-08d8096c78e4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2020 16:21:16.5105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Rf3hClJYeVavGs/cij1YiypkqUXc/Q4TnR7dSCvps4GbIdG+SsXoU/9S5FWlxmJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2362
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Eduardo Habkost <ehabkost@redhat.com>
> Sent: Thursday, June 4, 2020 3:54 PM
> To: Moger, Babu <Babu.Moger@amd.com>
> Cc: mst@redhat.com; marcel.apfelbaum@gmail.com; pbonzini@redhat.com;
> rth@twiddle.net; mtosatti@redhat.com; qemu-devel@nongnu.org;
> kvm@vger.kernel.org; kash@tripleback.net; geoff@hostfission.com; Dr. David
> Alan Gilbert <dgilbert@redhat.com>
> Subject: Re: [PATCH v13 1/5] i386: Add support for CPUID_8000_001E for AMD
> 
> On Thu, Jun 04, 2020 at 09:06:27AM -0500, Babu Moger wrote:
> >
> >
> > > -----Original Message-----
> > > From: Eduardo Habkost <ehabkost@redhat.com>
> > > Sent: Tuesday, June 2, 2020 12:52 PM
> > > To: Moger, Babu <Babu.Moger@amd.com>
> > > Cc: mst@redhat.com; marcel.apfelbaum@gmail.com;
> pbonzini@redhat.com;
> > > rth@twiddle.net; mtosatti@redhat.com; qemu-devel@nongnu.org;
> > > kvm@vger.kernel.org; kash@tripleback.net; geoff@hostfission.com; Dr.
> David
> > > Alan Gilbert <dgilbert@redhat.com>
> > > Subject: Re: [PATCH v13 1/5] i386: Add support for CPUID_8000_001E for
> AMD
> > >
> > > On Fri, Jun 08, 2018 at 06:56:17PM -0400, Babu Moger wrote:
> > > > Add support for cpuid leaf CPUID_8000_001E. Build the config that closely
> > > > match the underlying hardware. Please refer to the Processor
> Programming
> > > > Reference (PPR) for AMD Family 17h Model for more details.
> > > >
> > > > Signed-off-by: Babu Moger <babu.moger@amd.com>
> > > [...]
> > > > +    case 0x8000001E:
> > > > +        assert(cpu->core_id <= 255);
> > >
> > > It is possible to trigger this assert using:
> > >
> > > $ qemu-system-x86_64 -machine q35,accel=kvm,kernel-irqchip=split -device
> > > intel-iommu,intremap=on,eim=on -smp
> > > 1,maxcpus=258,cores=258,threads=1,sockets=1 -cpu
> > > qemu64,xlevel=0x8000001e -device qemu64-x86_64-cpu,apic-id=257
> > > qemu-system-x86_64: warning: Number of hotpluggable cpus requested
> (258)
> > > exceeds the recommended cpus supported by KVM (240)
> > > qemu-system-x86_64:
> > > /home/ehabkost/rh/proj/virt/qemu/target/i386/cpu.c:5888: cpu_x86_cpuid:
> > > Assertion `cpu->core_id <= 255' failed.
> > > Aborted (core dumped)
> > >
> > > See bug report and discussion at
> > >
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.
> > >
> redhat.com%2Fshow_bug.cgi%3Fid%3D1834200&amp;data=02%7C01%7Cbabu.
> > >
> moger%40amd.com%7C8a2724729b914bc9b53d08d8071db392%7C3dd8961fe4
> > >
> 884e608e11a82d994e183d%7C0%7C0%7C637267171438806408&amp;sdata=ib
> > > iGlF%2FF%2FVtYQLf7fe988kxFsLhj4GrRiTOq4LUuOT8%3D&amp;reserved=0
> > >
> > > Also, it looks like encode_topo_cpuid8000001e() assumes core_id
> > > has only 3 bits, so the existing assert() is not even sufficient.
> > > We need to decide what to do if the user requests nr_cores > 8.
> > >
> > > Probably omitting CPUID[0x8000001E] if the VCPU topology is
> > > incompatible with encode_topo_cpuid8000001e() (and printing a
> > > warning) is the safest thing to do right now.
> >
> > Eduardo,  We need to generalize the encode_topo_cpuid8000001e decoding.
> > We will have to remove 3 bit limitation there. It will not scale with
> > latest configurations. I will take a look that.
> >
> > For now, best option I think is to(like you mentioned in bug 1834200),
> > declaring nr_cores > 256 as never supported (or deprecated); and throw
> > warning.
> >
> > What do you think?
> 
> I believe we can declare nr_cores > 256 as never supported to
> address the assert failure.  Other CPUID functions also look
> broken when nr_cores is too large: encode_cache_cpuid4() seems to
> assume nr_cores is 128 or less.

Let me know where to add this check. Or if you want to take care of that
that is fine as well.

> But we still need to make nr_cores > 8 safe while
> encode_topo_cpuid8000001e() is not generalized yet.

I am working on a patch to address this now. Will send it soon with other
patches(addressing uninitialized node_id).

> 
> > >
> > >
> > >
> > > > +        encode_topo_cpuid8000001e(cs, cpu,
> > > > +                                  eax, ebx, ecx, edx);
> > > > +        break;
> > > >      case 0xC0000000:
> > > >          *eax = env->cpuid_xlevel2;
> > > >          *ebx = 0;
> > > > --
> > > > 1.8.3.1
> > > >
> > >
> > > --
> > > Eduardo
> >
> 
> --
> Eduardo

