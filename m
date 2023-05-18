Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5788770889F
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 21:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjERTvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 15:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbjERTvE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 15:51:04 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2065.outbound.protection.outlook.com [40.107.220.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43BDE6D;
        Thu, 18 May 2023 12:51:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z8yWA45AjZGd7Wku0k0t4Z2gZudEzppmMTQmxmZVtG+6vA2Mc/N/qxXtYaNGiFERvpHr4MLHQ73ukYeOlTIulg9I8f3id6GnT4DnsE1a/yIHDr1KTgKccKuz8xZJchQfdpFVurQ7xBKHppKEj5YlCpYbmhzFGxlLajkrs/EDaxzLBhv/Sf5hO4yvEVF3LPyCkODDx1fkQAFEFP8/7h3JrlA1bE3+PjEOXRP7TXkSJhvjjqPfjpjiIdZAuPZii5skWkHOhGsX8GwRSrX2Z6+gylK8FyHvbExSEIHVffvJfl8oVCw4EPoibvdfqQcFWbI9aSdqzpre3T6bSc+d1GDVzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m7fBIhCoyq8ZaDvAZ1+zTUyTyDQkQzr/8pBunfZXGQk=;
 b=OgYqaRpeLzvsxEwpcgUmM5MOX8Z/oEMcvyg6Y1mlVEykD2hSaaGX3bms1tcjReSu7/dgQhjkwBwThb64SeEDDg3Y/CgJcMQrD406KQ5YShjnisT7muEZODBofMY98hW1oKlfj7HlrWcAIl21voH4RQwQVd/4ECu0igoyDn9CCLA5qR9k+HrT9xjBi7GWWykhyB9uZgO0jXpd8ztLfvA4/z/toZMp9cBO55WPTcp2OdC3IPu8Q8WMo7v5Y/JpPef73B+cOMah4wxzNNHj8qH6OUNoHcbV4ICTDlor2MuBcGgSPXfMqgepu3ikkT5xKXndv4mXTN1oZ/0p84OYpRXzJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m7fBIhCoyq8ZaDvAZ1+zTUyTyDQkQzr/8pBunfZXGQk=;
 b=FoZYgfUBJIylq7U0O5H6FJ6hhi++sOfF95E9qWS8yMYWRuf3agRiqiCW6juZ3xwIJV7fOtIupyqTjspET8VHEBWLb4KKLHTKBVaogtZ3ridL0G4dksl8HL6cmEc/SRUWYWzd/d6FW5nxRnARIyYk/Apze8dWrtpkd/gwuYvNRYg=
Received: from BL1PR13CA0144.namprd13.prod.outlook.com (2603:10b6:208:2bb::29)
 by DM4PR12MB6566.namprd12.prod.outlook.com (2603:10b6:8:8d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Thu, 18 May
 2023 19:50:59 +0000
Received: from BL02EPF000145B9.namprd05.prod.outlook.com
 (2603:10b6:208:2bb:cafe::8f) by BL1PR13CA0144.outlook.office365.com
 (2603:10b6:208:2bb::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.6 via Frontend
 Transport; Thu, 18 May 2023 19:50:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF000145B9.mail.protection.outlook.com (10.167.241.209) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6411.11 via Frontend Transport; Thu, 18 May 2023 19:50:59 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 18 May
 2023 14:50:58 -0500
Date:   Thu, 18 May 2023 14:50:22 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sagi Shahar <sagis@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Anish Ghulati <aghulati@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Houghton <jthoughton@google.com>,
        Anish Moorthy <amoorthy@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Babu Moger <babu.moger@amd.com>, Chao Gao <chao.gao@intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        "David Woodhouse" <dwmw@amazon.co.uk>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Guang Zeng <guang.zeng@intel.com>,
        Hou Wenlong <houwenlong.hwl@antgroup.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Jing Liu <jing2.liu@intel.com>,
        Junaid Shahid <junaids@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Leonardo Bras <leobras@redhat.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Li RongQing <lirongqing@baidu.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Michal Luczaj <mhal@rbox.co>,
        Mingwei Zhang <mizhang@google.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Paul Durrant <pdurrant@amazon.com>,
        Peng Hao <flyingpenghao@gmail.com>,
        Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>,
        Robert Hoo <robert.hu@linux.intel.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vipin Sharma <vipinsh@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Wei Wang <wei.w.wang@intel.com>,
        "Xiaoyao Li" <xiaoyao.li@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Qinglan Xiang <qinglan.xiang@intel.com>,
        "Kai Svahn" <kai.svahn@intel.com>,
        Margarita Maroto <margarita.maroto@intel.com>,
        Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Nagareddy Reddy <nspreddy@google.com>,
        <linux-kernel@vger.kernel.org>, <Dhaval.Giani@amd.com>
Subject: Re: [ANNOUNCE / RFC] Periodic Upstream Call for KVM
Message-ID: <20230518195022.osqj2b34vijvrfrm@amd.com>
References: <20230512231026.799267-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230512231026.799267-1-seanjc@google.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000145B9:EE_|DM4PR12MB6566:EE_
X-MS-Office365-Filtering-Correlation-Id: e43c1d9a-7af9-45d1-b9e9-08db57d933de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PVSoziAU0uVC5XQz5iPEKG/BpprgNZShSrPcoNCRtDtioOtHAwLWnPswLiRmHBZK5tqspIWRMFKQdWrsNCjzHiTl1Q86gZIKsulAX+QAe76CZtT5B6E6UF1gFCEt1IbtvZAqHG+C9vHShrVvHex1a5MVpVrbJsRKEtZcsORbIlT+/WCoOdTtrJt3uZ3bl8uWvBMH/YEZhRnpfOaUl7W6Zx9U6Y7rW6oSlMSyKUCaFEUB6gaKipJD435lttv3yZmmj4jbRjPqAkC7GavDYBTdvbABpQIRWjxyxWql2PsMEI7nzNH3qDk+72Acq4hEdzFb12XWNvUm3hYGplvXa3gisppjcTkYoMogJidMYzHVae8dJc958xxjWUeVvp7lsZWRtd3lTO+Z16DHU1SMQrJ5FOpQn+C1tK8RRJWjoOj4so+hal+yYlDbLj57RpQ1GaKsHIYTOMHvHBu0rHYfEPmbAxkd9JxQQb39F0aI2Xphh9UWApQEPqRYM6EuYztNvIwmmtRWBzxKnXOlAQlzkg4gTYY3cz8Dz37dNJrIZDFYjmDRV0wObcyTbZ7/UKGlfSvI9te0B6qvgZoPLxSEbhXSs60VEYElAdAv/ObABsE5vkWUsUpJpF7TFfJVhpt520dPmaN/dT2u5iSn45aM8Lp+Iy6qTvI8GzzrFXrBTUqCUENP2jxkx0cOBWI0wejY316Mqy4A/ZEerz5nIjNHfcIB/WMuvmtfH6+o9LPHNQ89ZooHLjR1+FhkJwd1eTerOHC7G1VLW959hv3OQVgL5Eit9Q==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(396003)(39860400002)(346002)(451199021)(40470700004)(46966006)(36840700001)(44832011)(86362001)(36756003)(7366002)(8936002)(356005)(40480700001)(82310400005)(8676002)(7416002)(7406005)(82740400003)(81166007)(47076005)(2616005)(426003)(336012)(40460700003)(6666004)(16526019)(83380400001)(2906002)(36860700001)(41300700001)(70206006)(186003)(26005)(1076003)(70586007)(4326008)(316002)(54906003)(5660300002)(6916009)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 19:50:59.2186
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e43c1d9a-7af9-45d1-b9e9-08db57d933de
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000145B9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6566
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 12, 2023 at 04:10:27PM -0700, Sean Christopherson wrote:
> I am "officially" announcing a Periodic Upstream Call for KVM, a.k.a. PUCK.
> The intent of the PUCK is to provide a vehicle for having "in-person" technical
> discussions of features, designs, problems, etc. that are cumbersome to discuss
> asynchronously on-list, e.g. because something is too complex, too large, etc.
> 
> Exact details are TBD, and obviously can be adapted as needed.  Proposal:
> 
>   Frequency: Weekly
>   Time:      Wednesday, 6:00am Pacific Time
>   Duration:  60 minutes
>   Software:  ???
> 
> My thinking for weekly versus fortnightly (every other week) is that we can always
> cancel meetings if there are no agenda items, and bump down to fortnightly if we
> are constantly canceling.  On the flip side, if we go with fortnightly, it'd be
> more difficult to clear the backlog if PUCK gets booked out multiple sessions, and
> PUCK would be less useful for discussing urgent issues.
> 
> As for the time, 6am Pacific Time was the least awful (and still quite awful IMO)
> time I could find that gives the majority of the community a reasonable chance of
> attending.  I know we have developers in at least the below time zones (and probably
> more, though I don't think anyone works from Hawaii, and if someone does work from
> Hawaii then they have nothing to complain about :-) ).
> 
>   PT   (6am)
>   MT   (7am)
>   CT   (8am)
>   ET   (9am)
>   WET  (2pm)
>   CET  (3pm)
>   EET  (4pm)
>   EST  (5pm)
>   CST  (9pm)
>   NZST (1am)
> 
> The obvious alternative would be to invert the schedule and have the sync be in
> the evening/night for Pacific Time, but to get 6am for ARM folks, we end up with:
> 
>   PT   (10pm)
>   MT   (11pm)
>   CT   (12pm)
>   ET   (1am)
>   WET  (6am)
>   CET  (7am)
>   EET  (8am)
>   EST  (9am)
>   CST  (1pm)
>   NZST (5pm)
> 
> which is quite unreasonable for pretty much everyone based in the US.  Earlier
> than 6am for WET is likewise unreasonable and will result in people not attending.
> 9pm for China is also unreasonable, but I hope that it's not completely ridiculous
> and is doable enough that people can at least attend on an as-needed basis.  Sorry
> Kai, as the sole representative from New Zealand, you get hosed :-(
> 
> Wednesday because holidays and (short) vacations most often land at the beginning
> and end of the week.
> 
> 60 minutes because I'm not waking up at dawn for anything less, and anything
> more will likely have dimishing returns, especially for folks on the edges of
> the time zone table.
> 
> Lastly, the big unknown is which video communication software to use.  My default
> is obviously Google Meet, but I've been told that Meet is unusable in some
> countries. :-/  My only requirements (beyond basic, obvious functionality) are
> that (a) there's a web interface (no install required) and that (b) the calls can
> be recorded.
> 
> To kick things off, I am leaning toward a "launch" date of May 24th (Pacific),
> with KVM guest private mem (a.k.a. UPM) as the first topic.

Hi Sean,

Seems like a great idea to me.

We have a number of people at AMD interested in joining for the UPM topic. Is
the proposed 6am Pacific slot still the plan? No objections to using Google
Meet on our end.

-Mike

> 
> Please chime in with thoughts and ideas!
> 
> 
> P.S. This is an open invite, feel free to forward at will.  The Cc list is by no
> means intended to be definitive.
