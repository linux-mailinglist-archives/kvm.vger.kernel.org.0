Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48909325779
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 21:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234322AbhBYUVP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 15:21:15 -0500
Received: from mail-eopbgr770078.outbound.protection.outlook.com ([40.107.77.78]:40355
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232081AbhBYUVG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 15:21:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K1naBvJQghzfkXAsBqarOIqfLTX7or148jyWY4dA8Gp4MWXGkiKBjThzJhpiUI9ixopKe7OQki/InMqjd2GVX3J/2OXZW8hGi5oyrL0AQgb5NX9UnZLwyoJlJlyGr0aYxL4QvkrfMmwC+RurJmPkTdzn8J/a2OfWa97D2goozvj9Rpo1KYGXzFCzDnswS2KlwuyghH9rk4+++VvrIuUiLJY8PyYJX5v3jtvyW9zt1KtAsbpd8VhefT+xGxP/yaRl5wZWm1ne8uoqOT93I8Wtlyes7k+4Q2aBGrOT9BN0exjGsmFdr16dwvRkVBOXlovTpZkfveHmhR9zkETe1M7vuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UcEQ1J9XU2WaKe2EW9sDYjYwgHsOt8XtlW/H7d5hhgk=;
 b=gxYllyMba0j2+FrFVRc/y7i08VL9JTK00VmhzqSTZnT1QYbpxs7mnogN0/VVE9c6VrM5t5jd9jYf2aP/VVm9pLjAAW21pJWuVJUbmWLS/ZU3qKqs/syVoUc9oZlzTyryT6gjIzPJGv9+H2DtEws639z4jXpadMjUfTdyBeceWKM4ivObdWXdeXyUlHSUMoZYsCY1xYnf1/J5qtPoH4CiWfrqrAnw9FIunFnUnNPCj5IYN4+dfkIp7cAnr6gpqDDlhb8VA6AcOfugF4DFCu8Zg2RMF1UxUis04E5YGzf6yv28YsGcWkb4ZAIA/Oj5pgnbPq++zqBQWVWo64Qtluvv2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UcEQ1J9XU2WaKe2EW9sDYjYwgHsOt8XtlW/H7d5hhgk=;
 b=y2QhgpEb8cj1KJ4lW1JqC9o7cC8GuAAvtOmrHogBo9gE8bAYLpuibXg2P2lufKoAjA42hCQCndHVhjUMuV6I7YYaHtc/P3TFYOb14kGKozlzX2mc9ptR6RSMUBe6tIAzcIHe7gc8y1h7FKp3kfnfW3JPFykO0LxXRZj3V8skonI=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4429.namprd12.prod.outlook.com (2603:10b6:806:73::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Thu, 25 Feb
 2021 20:20:14 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3890.020; Thu, 25 Feb 2021
 20:20:14 +0000
Date:   Thu, 25 Feb 2021 20:20:08 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>, "bp@suse.de" <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "srutherford@google.com" <srutherford@google.com>,
        "venu.busireddy@oracle.com" <venu.busireddy@oracle.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>
Subject: Re: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST
 ioctl
Message-ID: <20210225202008.GA5208@ashkalra_ubuntu_server>
References: <cover.1612398155.git.ashish.kalra@amd.com>
 <7266edd714add8ec9d7f63eddfc9bbd4d789c213.1612398155.git.ashish.kalra@amd.com>
 <YCxrV4u98ZQtInOE@google.com>
 <SN6PR12MB27672FF8358D122EDD8CC0188E859@SN6PR12MB2767.namprd12.prod.outlook.com>
 <20210224175122.GA19661@ashkalra_ubuntu_server>
 <YDaZacLqNQ4nK/Ex@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDaZacLqNQ4nK/Ex@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0401CA0032.namprd04.prod.outlook.com
 (2603:10b6:803:2a::18) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN4PR0401CA0032.namprd04.prod.outlook.com (2603:10b6:803:2a::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Thu, 25 Feb 2021 20:20:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: be69d3db-1c59-4f45-c1cc-08d8d9cac229
X-MS-TrafficTypeDiagnostic: SA0PR12MB4429:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44293F37A53067E9CD1EC43F8E9E9@SA0PR12MB4429.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GLNfKRMKrqP5QHjd3Z+wkdWcc+Ce8iZQbT3xReO8+O2RslXNOqy6NSeTwNJGc1V7F47UruJx2kg9+jbpCAOreTq74MW9ZQdD5TcBUQi1rBNtMxuDgQIA9gfDSQqoPurhP1WeRYUZmwGEnKYMDpUQPkidaWRiTkr+rvqvSCp3zWRo2Z2M4hhGNfT1ZiWwm/S8T7a5oIY0cZbNu6b+XHhsnif2n/o3AM6dPXaRdJlQ6su1D8tq6eCbeL2BhbuKIWzrHH1PnPW0lQ5StdKsJE8YAhLJwCrdUMzBsTE/48VRy6D1OKq1DmjAfAxoIOoAKWU2OkEUplEtNSryleBcUYwKu6oA4JFyQb7GzUlyEkAeobysuYN/XzmSk7xO58sCblA0BmlVa+1diHZaZGz1SajbfXDEBP0D2NGmk/yL/4a/7H+2zcmdf5W0UMkfCtiWewpCbFjJ/zAX7hnug1xTCfAR+midBmyRtqM4DL4igl3KXqKVgTGizDfDzTL1hDD7XCEOhS7m+AjjHCJvCu4gWodBTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(66476007)(66556008)(66946007)(4326008)(186003)(7416002)(52116002)(6916009)(6496006)(478600001)(316002)(9686003)(55016002)(26005)(44832011)(2906002)(33656002)(86362001)(1076003)(6666004)(5660300002)(8936002)(33716001)(8676002)(956004)(16526019)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ASf2dSs9xJxBm3sHvSVm7z2Bz1r/f6MJnNxqXwRbDRqvm4HNHINIPIIgtBgL?=
 =?us-ascii?Q?vMpoFFdZVD0oq8uWCrEm1F6rm0VDlBOlzf3TP1e+2Wd0GvnlLwVY5/iwLDGG?=
 =?us-ascii?Q?W9YgldNVG/B9ZoUdjsNatDF8Ipp7kxwyHsw471YjLApvpIPtA4WbP+j/GcGw?=
 =?us-ascii?Q?OHtB/gIkgi+6dkHGEStds6MR5NPFI88b4mJCWYU3kAeF5ZPi/xiYc5q8VRbv?=
 =?us-ascii?Q?3jUAgu95qZGJr34dOEm1O9FRPY5G7C8Ar1KFbs6NimAs4sNw4ErYjYDATYge?=
 =?us-ascii?Q?CnQXIa13jTlfD00sgmI/30Ekgairvi3R5YovFLYmuEDR/rqFbh7c9omPF7Pv?=
 =?us-ascii?Q?haEpZxGVKzi9U+owa5uKN/zC99RUUWug2YGAyVGsMv7j5Je1UT6tbN0rjJsv?=
 =?us-ascii?Q?CMmVtUKd0JTNBQSW6OhRQECLP0xN+DjAponCWjjNKS8oquSymDPPaSkbnTZl?=
 =?us-ascii?Q?wpmvrbRo2MnAKl8D8JZL0LDM2BieO2aUSZEH4i26AFIBhg+SbJS6otcad0Sr?=
 =?us-ascii?Q?FVu+wT1u0dRsEa2r5/8xuixMLFGRFttB7ejBZCChQGAX5ucKtYPmiqvSnjCP?=
 =?us-ascii?Q?DCbvoG413wrnbc7q3mF+k9wgpVmRrJybTxdDVaHv6LCZaNA78EJc/avcoFpb?=
 =?us-ascii?Q?SMB6o24IbCFgEozoK+55LCgq8VTyGnP5talRuQk6Ju8FrnI5tWgIJmEyFYHr?=
 =?us-ascii?Q?LrjQoZRZL38NN/zZKhPp1JzykBQZrvEjyKBKyM2eoY4kmNrfvP8/d+S6Hgiw?=
 =?us-ascii?Q?8V5wkr0VhXqexz1SGoxrGQXMBRQeCgML2xGfaJdVl1aTNak6f7/RyUjB5foA?=
 =?us-ascii?Q?u2lKmj4AiTK3ciYChbCQFe3NlFwPhE9N0cFSikfyZrwZe5rJWQ88rGKRKBXJ?=
 =?us-ascii?Q?09SFy/l3wFfjC1Ra3Q0oOx6lxtPliSIOPw45/eFIA41OtsaKGaiD1igyPk9g?=
 =?us-ascii?Q?cGVN/0JigUxrf/aBcBijtFJX0YO9CVrjJvRQ6+kK9HdBoeGGAxTC7yAMSAz8?=
 =?us-ascii?Q?6ImO+4PWZX3fH956cFmwIN41wcPkCV09mGk1yzVvxb/5N400PXCH3a5etJgi?=
 =?us-ascii?Q?hWAZ+x233CkfW6L21GdGg4XgoNLiCh2dSKur01uSq+tykohBwhOuD4WRq65V?=
 =?us-ascii?Q?/l3KwCxONZW0/oHuwSXyv9fWaveeYU1VsUE3KK3ggBCg5AJ3zkApisLJREeX?=
 =?us-ascii?Q?LafWhcU75pI3OSPrECjputkFeozc+1KcHLo/KXSauxjcZGMacy8imGUND7Qj?=
 =?us-ascii?Q?1bgJOVaXzzGqqzHlymd74DdiZrXSeSm+TaJ4QGH9eq5NSA36R33dRnv7KtK6?=
 =?us-ascii?Q?UVSltu6h4zOQYxYYMWyqoCrq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be69d3db-1c59-4f45-c1cc-08d8d9cac229
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2021 20:20:13.9711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6GehbuaeoeIkyil/JeaNCiQ2yXThS+RM8vwgj38Z7inEVemsW0RoTHzlfkkCPfkPfM57HsVxR94Ohkw1+gEC6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4429
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 24, 2021 at 10:22:33AM -0800, Sean Christopherson wrote:
> On Wed, Feb 24, 2021, Ashish Kalra wrote:
> > # Samples: 19K of event 'kvm:kvm_hypercall'
> > # Event count (approx.): 19573
> > #
> > # Overhead  Command          Shared Object     Symbol
> > # ........  ...............  ................  .........................
> > #
> >    100.00%  qemu-system-x86  [kernel.vmlinux]  [k] kvm_emulate_hypercall
> > 
> > Out of these 19573 hypercalls, # of page encryption status hcalls are 19479,
> > so almost all hypercalls here are page encryption status hypercalls.
> 
> Oof.
> 
> > The above data indicates that there will be ~2% more Heavyweight VMEXITs
> > during SEV guest boot if we do page encryption status hypercalls 
> > pass-through to host userspace.
> > 
> > But, then Brijesh pointed out to me and highlighted that currently
> > OVMF is doing lot of VMEXITs because they don't use the DMA pool to minimize the C-bit toggles,
> > in other words, OVMF bounce buffer does page state change on every DMA allocate and free.
> > 
> > So here is the performance analysis after kernel and initrd have been
> > loaded into memory using grub and then starting perf just before booting the kernel.
> > 
> > These are the performance #'s after kernel and initrd have been loaded into memory, 
> > then perf is attached and kernel is booted : 
> > 
> > # Samples: 1M of event 'kvm:kvm_userspace_exit'
> > # Event count (approx.): 1081235
> > #
> > # Overhead  Trace output
> > # ........  ........................
> > #
> >     99.77%  reason KVM_EXIT_IO (2)
> >      0.23%  reason KVM_EXIT_MMIO (6)
> > 
> > # Samples: 1K of event 'kvm:kvm_hypercall'
> > # Event count (approx.): 1279
> > #
> > 
> > So as the above data indicates, Linux is only making ~1K hypercalls,
> > compared to ~18K hypercalls made by OVMF in the above use case.
> > 
> > Does the above adds a prerequisite that OVMF needs to be optimized if 
> > and before hypercall pass-through can be done ? 
> 
> Disclaimer: my math could be totally wrong.
> 
> I doubt it's a hard requirement.  Assuming a conversative roundtrip time of 50k
> cycles, those 18K hypercalls will add well under a 1/2 a second of boot time.
> If userspace can push the roundtrip time down to 10k cycles, the overhead is
> more like 50 milliseconds.
> 
> That being said, this does seem like a good OVMF cleanup, irrespective of this
> new hypercall.  I assume it's not cheap to convert a page between encrypted and
> decrypted.
> 
> Thanks much for getting the numbers!

Considering the above data and guest boot time latencies 
(and potential issues with OVMF and optimizations required there),
do we have any consensus on whether we want to do page encryption
status hypercall passthrough or not ?

Thanks,
Ashish
