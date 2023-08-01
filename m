Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1AF76BA4B
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 19:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234046AbjHARDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 13:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233948AbjHARDT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 13:03:19 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8EB2139;
        Tue,  1 Aug 2023 10:03:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h1WPP3znSXD0LZMbXUOq+Sh8Uer08BkCrmvmJkYqfPwLhO1tLr3BzmpM9/Jpc8vrq3spS4iAthyXW/MRqdb1P0wO5bAdb79nolds0TIXhM+/62YmhB5PfD0KP73xPimSMIHGICKYe6Bx+1ORaCPGV/etXL3JXf791NUFLhjKlNm+jLdOlD27J/ojsJygacaqubs71edPDi8lj5dvFwfeFI+WVpV+C8Hi38DHAdmuKkUzlxdTBUFVXD3PtHx8i+5dmtVyue4Ifld+tmpu8zg0NeACS3s4JRy2H9gnn/GcNyZPC3t3NuGILbbXmj+mUXdBRb5MpxJsJlYX3W7W9U5omA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EjagZb2b4z4W/WapoanDUZksz+Xl37aTScUqt7n0EH8=;
 b=ky9S1FEPRcaaE3suSMrZFqiDgDsTpo7AuL3Ov9FgkXv8+C29pma2rZn/Nm7O6C5L5AWsG6F3Yvnfa0AkIU66dvTLhmQSfu8u0mT0WCuPlUowanjUe5RACmCAkGs3kamaXP/khNOJnHSB6TmrEmrQM9z6VypMUyeVeEjZ+BPECGQlrGdg10sHqLoYTipKu+J7giy6TYUM4gdpGYH9sGZptp6Ylku0vmPnF/X9dxi/nblVUBYL6f50HLn/x8gLRd47m6+pj9dyh5VZFH3BXZdApll8/nNNMqNmPT4jmqOn2SPN34BwjyfNnq9XAxKyzhVO2La6zj+N9Pq7cPBbIqJe0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EjagZb2b4z4W/WapoanDUZksz+Xl37aTScUqt7n0EH8=;
 b=XLbopf9KTXsE4P/5zYsFvfESS5gcEN5quoCIGBJon2ycif4cMLQ0EhrZG+u3BIhrCbM6kSk30MBquaTO7ozJAMT5UOiKUm5LLEWqOSSAorQp2bTi3RU2qCn09X292QOFdwABkIiPy75QI3mHf2IByCfmImBrmUX1z2fj0mPoapk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by CYYPR12MB8890.namprd12.prod.outlook.com (2603:10b6:930:c7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.31; Tue, 1 Aug
 2023 17:03:14 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::1be:2aa7:e47c:e73e]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::1be:2aa7:e47c:e73e%4]) with mapi id 15.20.6631.042; Tue, 1 Aug 2023
 17:03:14 +0000
Date:   Tue, 1 Aug 2023 12:03:03 -0500
From:   John Allen <john.allen@amd.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, weijiang.yang@intel.com,
        rick.p.edgecombe@intel.com, x86@kernel.org,
        thomas.lendacky@amd.com, bp@alien8.de
Subject: Re: [RFC PATCH v2 4/6] KVM: SVM: Save shadow stack host state on
 VMRUN
Message-ID: <ZMk6xzfVF0C+sTuK@johallen-workstation>
References: <20230524155339.415820-1-john.allen@amd.com>
 <20230524155339.415820-5-john.allen@amd.com>
 <ZJYKksVIORhPtD6T@google.com>
 <ZMkie3B7obtTTpLu@johallen-workstation>
 <ZMkymz22bHTsFCTD@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZMkymz22bHTsFCTD@google.com>
X-ClientProxiedBy: YQBPR0101CA0347.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6b::8) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|CYYPR12MB8890:EE_
X-MS-Office365-Filtering-Correlation-Id: 2dae8b73-4060-4fa7-a520-08db92b131da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qXjwxtLRyUJy3m13/2i+U6UzHPSWfR3L0FtrTgphwSzAgqdewHE0vXCEvPqsBSWitbO3SOxbT1kCtGTUok9S9JgkIqH5FAKUA4y2aJWNuwQzXxhDq3SNqbDuwupuyAK6k9Z3vtpsNYD0v8ncyW7ynEp+3g9G00av2BLP4MHrk1r1mfcjGvLys+d8Ngj90Nm+UUum8Y5l32CCnwHHQIZhk634a0wnfTR7ickILQemLp4Oigi53Qk9tVdIw61TmlnlbW5ilSSI1FlFRy5bKfkvFckSDAdzZ3i4fh7hV0pOtK/4ZcwfWAgVTwpHtgPRfyLPggpdyPD56TaCw2PuYgoFvwbQ9zZpj9+pjOhQC/r3uWJ349h2tGar1yaahxE5ObCSaLSXQGXr9KDPzj/9enc9Z/D83cAJSN6t3/WnVYIGAFOHkZBtLIQPAwcYXF4sAW4JGOpBIboKNULeRaJJ8l6xXFERbDB3G3KkT7MuFo2vMhK/fjTctXNGZteDtof7D+ZZf1dqOxuPtdL+J1XXwlnGGjobN7T+yDyt52mOyi30U9DcYeF8I0UEd4YpmbzbE/4Roe5B3Z3k1M/RuYw7iDuUfEweGuCReG7O+gHtnuGuTHs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(396003)(376002)(366004)(136003)(39860400002)(346002)(451199021)(86362001)(38100700002)(2906002)(6506007)(26005)(186003)(44832011)(8676002)(8936002)(5660300002)(41300700001)(83380400001)(33716001)(4326008)(316002)(66476007)(66556008)(66946007)(6916009)(6666004)(6486002)(478600001)(6512007)(9686003)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9nHCfEseC9creXYF8ujSBmp531syf8mUZUi7lSWuOzBOXi1BkLUeoRTt+DCM?=
 =?us-ascii?Q?gwXBL5Qbowou3QvuKu2JXbV3B+6dkIBozgJOTql7PXwXluEBbrTdGm8tyJe3?=
 =?us-ascii?Q?mtxZjYwyy3mOwLJZlZyQqtyJR7Wta5WhMUA9euTXolw9/9gJJQcfLXjdypqc?=
 =?us-ascii?Q?cxmeCsVtH3qL0aHBr1kxtrjfGrgx5aig7yejXW+fWWlvuJpx1JHWg9Aotf8A?=
 =?us-ascii?Q?1Q2aLtN3sLfz81DfSVKGTH43oN1m/ogZPpmRGrs2vPCUFHHkFfRpR4DROfuA?=
 =?us-ascii?Q?LoIEd2C/R0cuSqUy5u+hHsLcPlpV/todm6vw6GyINXY7nkW/COGm70hyBhmE?=
 =?us-ascii?Q?hr83zklmwNKt1CCGcmW0p1LzRgkzaRFaV5zrS+uPta2c1NuQW7CdeTdQ2rIF?=
 =?us-ascii?Q?cKI9HloymZC8XMPZ5bSPsmPnloa7if5wxVr6g3MatY809AnkGi+z9h2JzaS+?=
 =?us-ascii?Q?FwvRaZD4A3IrJimk5w2RPF+bIoB4hCCGsA6X/512XDBj2dWfgvTETT64p13m?=
 =?us-ascii?Q?Bq/iPHYI8MDFPLi6FecjAJt1Xhxrv70P8nWH71cszpO3hcZ1acVLBRzb48nI?=
 =?us-ascii?Q?qhCwV/OdfRRTqZislpWSK7l052WZbKzHAblVdspZjLg1ClDKdIDSOIiAgVmZ?=
 =?us-ascii?Q?AbpDMoccmdWNltOPy7tWWOKH5ps0re5+tK08Y/zTsxma+9RzwVsWwMlDj2Na?=
 =?us-ascii?Q?XYxrJ1hcTVLIVuB/uqtRzZjfFqh6WLEbGGhntpzonau5mUTtLH786lfBzE0A?=
 =?us-ascii?Q?X0Cw7Fk8Hu27OOdypNzvEZbRCTUsGMuckGXD/fh31g2CnF3iMD3g0VZ+Dbl3?=
 =?us-ascii?Q?MI3KU8eRS2n+NYYu6M91AB8+U813xdaklaFNxmRHsJF00GsLEZF5y1z091Cn?=
 =?us-ascii?Q?zNzdeuY/iSvJAR3rxsi6QR61+1YpFzOXIIOF+kPEPDBZmH05aiZLQW/7B3Sw?=
 =?us-ascii?Q?SyrBrxFe+yoBHwTNBt1jX5mF5c2RjBVO+809TVzEz3e1JRKCJ9UDROUAx6lu?=
 =?us-ascii?Q?wtn5H1A5j4C4Bh0GLI+HI4E/xJqVHWAI7qVDwd/QcD/wrk+mrogbu07xKjyX?=
 =?us-ascii?Q?f/3ZyFgvaekhWYBGpzMif0//AqwJpWlysfzsD6j2XrWVtfc7EZkpPCsfcllT?=
 =?us-ascii?Q?jeqbkt6ng2yuKD4h7DEgackUQMRQKw+uc/lCizbz2aUwAFQnR20P9o72k4Ld?=
 =?us-ascii?Q?gPx7moBwKF+yYaUkL6g7sjLbTLvyc3K3PlAHdGRYoC2z/S3DyCLCNmayVkU6?=
 =?us-ascii?Q?35mswI/plVX6GDTkMbO87GqjhTtQVKn7nb9e1Jqea0WSLV0eI9LuBx4fAGFk?=
 =?us-ascii?Q?45nD17X/tq6dZY6zL6ixt1EISJzBgtG/0MYoOQ5jjXSd7RNe0r3zF8NJ46Uc?=
 =?us-ascii?Q?YGoMtG2CiJzQavctXzp4BU4AiQVs58UV3gPrvOafRs15rE41g4eLnjxZupf9?=
 =?us-ascii?Q?l4Y/MArbIy2GCQ/89ehgesTLE/Ywy9CkfYWFE1ONmBQtBUmMOpZWi02mTZt1?=
 =?us-ascii?Q?eS0/nD1Xo0q01Z07xydkAqhY2m3VtenUY7uC+ue2g2ndPIBL4EO1jW+M0psU?=
 =?us-ascii?Q?meoWCrmKl2asim23nxv8dgwdqZCg2cSdnEzl9T7u?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dae8b73-4060-4fa7-a520-08db92b131da
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2023 17:03:14.7630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jhyQ3wUdwSPAsE0su2HhPvqX4gdC6d+mMAdIBTBAnYNhQrcbcFI/NwdOWRPUjC4w/pZYJuE78wFBq+zsLYcztA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8890
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 01, 2023 at 09:28:11AM -0700, Sean Christopherson wrote:
> On Tue, Aug 01, 2023, John Allen wrote:
> > On Fri, Jun 23, 2023 at 02:11:46PM -0700, Sean Christopherson wrote:
> > > On Wed, May 24, 2023, John Allen wrote:
> > > As for the values themselves, the kernel doesn't support Supervisor Shadow Stacks
> > > (SSS), so PL0-2_SSP are guaranteed to be zero.  And if/when SSS support is added,
> > > I doubt the kernel will ever use PL1_SSP or PL2_SSP, so those can probably be
> > > ignored entirely, and PL0_SSP might be constant per task?  In other words, I don't
> > > see any reason to try and track the host values for support that doesn't exist,
> > > just do what VMX does for BNDCFGS and yell if the MSRs are non-zero.  Though for
> > > SSS it probably makes sense for KVM to refuse to load (KVM continues on for BNDCFGS
> > > because it's a pretty safe assumption that the kernel won't regain MPX supported).
> > > 
> > > E.g. in rough pseudocode
> > > 
> > > 	if (boot_cpu_has(X86_FEATURE_SHSTK)) {
> > > 		rdmsrl(MSR_IA32_PLx_SSP, host_plx_ssp);
> > > 
> > > 		if (WARN_ON_ONCE(host_pl0_ssp || host_pl1_ssp || host_pl2_ssp))
> > > 			return -EIO;
> > > 	}
> > 
> > The function in question returns void and wouldn't be able to return a
> > failure code to callers. We would have to rework this path in order to
> > fail in this way. Is it sufficient to just WARN_ON_ONCE here or is there
> > some other way we can cause KVM to fail to load here?
> 
> Sorry, I should have been more explicit than "it probably make sense for KVM to
> refuse to load".  The above would go somewhere in __kvm_x86_vendor_init().

I see, in that case that change should probably go up with:
"KVM:x86: Enable CET virtualization for VMX and advertise to userspace"
in Weijiang Yang's series with the rest of the changes to
__kvm_x86_vendor_init(). Though I can tack it on in my series if
needed.
