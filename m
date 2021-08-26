Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76493F90B1
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 01:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243769AbhHZW2C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 18:28:02 -0400
Received: from mail-dm6nam11hn2239.outbound.protection.outlook.com ([52.100.172.239]:3008
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243764AbhHZW17 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 18:27:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FKl7axMEtr8lkjufhYmrhBR9tBExEI8EQn4HPpcvUfwHpkrmyUqNt2yGxgIRXaTYbvDRMdZ3THX7XETwQwOmLwtB9pCner5uJWN/w81rIYbP9yIa0EdA3e6RXpqmz3Gh8JvZhy50IA3d6wUfiAG0qJmsbosixDRZKszQWaidvcZZBssf6YmOhJDVRuAjiyHE5fxcS293ohPTJmftU16J01nlUIpc8eSiFC9mKA+GqXZNL16C3mWtTrz11wCChyFPJB82GZnbGVwN1Rkat/Zsyxn1yloAYQlafWXrDjjmQxWqIjYl3uCfyHQ6XOpCSH87XUH7diGFmjHL0sSobm5nZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bEznvkHlj8jZDn8Gg5WtAr1gYrNRCDUL/RaSNLddoRQ=;
 b=eBUw0OcKXKdgWgZ5dcxFfu1CJDX5Vc2rODxSqkHBqhr+tcnZK/gvfeL+iyb87/oGRz4quP0Lizmxlfd5AQHUKqv2Z+vnGBy0Lz3lt7BTmcvgHnvCvehCHLFS3MlY96vMX6ws803bpcbF/9EQvXQJtOigI6y71oXuc7kqawNUy9pJF+VgARUbQHqFcxxh0KzQOM+FGZZ7sLH0LOev/ysrPg4f8pp7auJT8rqhfsvpAMbBek9T8QDBrZTPoD5M2r8gBCYjMDZGg1bDBfmeHXi3YxzE+p74Ta0rKxAlpChBW+oXeQVIXOF3OnwaPihaIjBuP4jcjW4OxyXAww7tQ1DO8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bEznvkHlj8jZDn8Gg5WtAr1gYrNRCDUL/RaSNLddoRQ=;
 b=QTlM+3V68BuO9XBS5hbLqbPffUwnR1KOcjbQUGLzdnuVBvS6psMmiAT4rnsSMWevq9fdbq1c99sytjFmJ0Ss0+8BjSvefH52ioOYDdYocZ0OEwhpNiMupYFYcgYXU2GADi6tDPXRgWknzGtrrnzbME1cYYIZq/SYLyxZCc+L+Cs=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB4293.namprd12.prod.outlook.com (2603:10b6:610:7e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 26 Aug
 2021 22:27:11 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::d19e:b657:5259:24d0]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::d19e:b657:5259:24d0%8]) with mapi id 15.20.4436.019; Thu, 26 Aug 2021
 22:27:11 +0000
From:   Michael Roth <michael.roth@amd.com>
To:     qemu-devel@nongnu.org
Cc:     Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>
Subject: [RFC PATCH v2 00/12] Add AMD Secure Nested Paging (SEV-SNP) support
Date:   Thu, 26 Aug 2021 17:26:15 -0500
Message-Id: <20210826222627.3556-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0084.namprd11.prod.outlook.com
 (2603:10b6:806:d2::29) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.77.1) by SA0PR11CA0084.namprd11.prod.outlook.com (2603:10b6:806:d2::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.19 via Frontend Transport; Thu, 26 Aug 2021 22:27:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2918e834-9f3b-4981-fb7f-08d968e0a58f
X-MS-TrafficTypeDiagnostic: CH2PR12MB4293:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB4293A6D9277A8D391D75526E95C79@CH2PR12MB4293.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?VEaItTWaaPmWwXRWM1bGhrRvSEcyPzYL/+MjoHu7FD0Cy9Znq4sT+nHHVv3K?=
 =?us-ascii?Q?mevO9i+DJ2S6dhIkpdgL7A1uNjc6P+znbJHqlGSUoCRV1XPNV5ZR0aF5kCF0?=
 =?us-ascii?Q?iUHjSZ/GfnHWLSpcBMrjXS4mDIst+jj75oFtqPeNclPv5X7gRTrkZ/CoiHMJ?=
 =?us-ascii?Q?TcA9hf5NxXYLjh7wTvpxrUt7V7byGgB7MHs84Fn3Kpv1YuRyuGY75UIE7Wfw?=
 =?us-ascii?Q?y2ugfoW5on4lvCY2y0bwwHd+t6C3VzjWplYtscwkANbHdUrnYt2asMJJwFYT?=
 =?us-ascii?Q?7x9VAAOs0Ggk6mLVJ6+lKuvX4ITmBotUfFWX4NxzX9Pf3gLN4ABsX/4UstbP?=
 =?us-ascii?Q?OBmSdfo3fKJs6aBWcPwxXrMhlmEZou0H0dCoPNFjfzL8mWttrJNcAKRknB36?=
 =?us-ascii?Q?uz7RyHYMRcWj538OR1M/dhaXu6sIVG5vXQm+vMLPpsU2H/6NISrbYo6M2KUq?=
 =?us-ascii?Q?PSH9iM7HELFjn1OoIhkLJQTzNr4j6Rd/cu0NcQDCrpEUsttJdzW31D9Ddomt?=
 =?us-ascii?Q?Q8JlYz8bkbraW0KpKENg8ANSGwol06nywSUuEaCylqzVjgZCyjSCGuIqYQPf?=
 =?us-ascii?Q?LJ79nLlTm+ChCM0Z3fA24m/kA1BmcC9y3fiRGxOos2GcKYzF1M8l0GY8UJWD?=
 =?us-ascii?Q?A0WZ6fyryxB9b1hcfMShtYJ2IPHK3DAMP94xtNmJXONb80q2OLkVmNPRz6F/?=
 =?us-ascii?Q?DA79C0Ys5LIaoBrsmidyX5Uo40SINvQhrtwalG4caE6TQ5kpgc6OyOdLG01i?=
 =?us-ascii?Q?w5MB1h02+KYRieqHxjZ72VGdGLJwYwJctcjFGnmCkN/vvX1JgttF9ZKEWgk5?=
 =?us-ascii?Q?zasOb2Xtvczrm+zHKGpbOpdtCw6Lol1HRwLGGLAwvgvRfDkiBJVNl+6j4PYt?=
 =?us-ascii?Q?gtYU0tgKv3EwVZmm3vq9fmyBUppZHSol50Mf/IT3Gu2giTYdqTvRiaqlL4VY?=
 =?us-ascii?Q?HbRxKVcLKLCSupFhF1GZSvdHIp6ttpEWSlKUTegyKypTLATi8wbY5YV+H+2n?=
 =?us-ascii?Q?ayCzk14zagrLQFN2krrvD+dA3y0JAocdc99JRdnUQfIS4aLftwsIbR5Cz9PQ?=
 =?us-ascii?Q?iK4J66GTmUX+P80u9DP2eqt7s0sgSI0eK3Vysmx2Bt45npSvdTHDAcwnJyln?=
 =?us-ascii?Q?DBZW1U4jZjnl8lnn8DkKqpCSfwbsp0srQmkncyIUWF2eyTTnki0ns8k=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(366004)(38100700002)(38350700002)(508600001)(6916009)(54906003)(966005)(66556008)(66476007)(1076003)(2906002)(5660300002)(6496006)(8936002)(52116002)(86362001)(316002)(186003)(6486002)(2616005)(4326008)(26005)(83380400001)(66946007)(36756003)(44832011)(956004)(8676002)(7416002)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hCKyLbq2WWaJhXig8NW/XLIDwz2Igbec5geEPVHax82HyQzKhULLUBDij2IK?=
 =?us-ascii?Q?Q7QTEGFIm//CQbn5R5a+PnfB87QWkCRNuaMgc6AMaZPNDs2SqpsZyJwVsX9F?=
 =?us-ascii?Q?XlKY+NoeTlq4ij+gcltyBfSnnL/+UAYNfnLO3C7ub8hVvizyC1/l7FSipbKX?=
 =?us-ascii?Q?08Q/Rb00Mcpa3bs7Z9vKC1jaEKjgcB42nx0haj79dbhVvzxXMW7SjfWJMN8G?=
 =?us-ascii?Q?l3QpI1CLwZgRCzRWneQgRRyb8Pnqn4BsAYOJrwTUkDgc1JtGri2xOODpPBrh?=
 =?us-ascii?Q?z7pMhe8h9FkZTt+tjCIIfKUzHBOFPWDi6u8J4lBF5MXSw+DUTj23X7jdLK5L?=
 =?us-ascii?Q?Al39QLMFSBHSH0OZ8+GwQTHvsQTlbh3Jj9gbAe4i9iy40w6vY6fgSsyL1TC2?=
 =?us-ascii?Q?ZBNnPLHgQfKnY5zxbOU2+cj/tI20MKeeLU7YLTNNvZhDVFy1jqXwLuL/P474?=
 =?us-ascii?Q?Gdvo+D+nLrUVyTTljXO1iSg+Ess/xlbhcbn9TWq10i7cD7OTIqsSLIysV5Xx?=
 =?us-ascii?Q?3+3VEvG7wx34gIqFGMTef4BR2LPl1twpNV4WSn3jupDKwXwIyKLmATmSsHmy?=
 =?us-ascii?Q?uQq/zjZN0hT8xctZbDTmnECmYRaGGwg5pzfWh5yHcjpQcgcsPqfP6TWUFRyM?=
 =?us-ascii?Q?EEXHHvXtGT6hV0NJ4h3s88c8F8thL36RmPDEz3u5PA2GbhzfBDdrtXD4hGzx?=
 =?us-ascii?Q?oLTWx18EPWhctzwoZKex236qn971NB3/XjStn1hao9k5riuqTkm1/J8PaG20?=
 =?us-ascii?Q?vx4vRVf8dr/BQKMI4dumIDvUSrlAYdABmDfDx25R9FTcnqm6JOUeuEm7MCEb?=
 =?us-ascii?Q?n3HoP1nWIWdxaw8gLw4SyCYnnA8SxXhuLu7M8KHJ4CQjCXZ4SOJ+lxISPHl5?=
 =?us-ascii?Q?quWDG462Vtqqmmju/98uFmNFwq0hZoi2OU2cIAtp9QuI7eAyJciD8/bGzrg2?=
 =?us-ascii?Q?jOCCs7LQrCz/AH1wNEgiUUErzlBTS0jBJs8x874PfZ+2vogrnlr3MZowUO5c?=
 =?us-ascii?Q?2Kaptiafk2TwLbG0/aUXuk+KtttWeGR8yuKUIdcwioBPNPI/QE0o3ft2ScfZ?=
 =?us-ascii?Q?cZy7Y9bXvdHL4Hp8WXqvgLoWDZGYOeUh5uV6yy+lubrwoeMMzsdEyY94/Hcg?=
 =?us-ascii?Q?1nz9yCteFs21gx/F2B8G/9L3df3sc86Q3n8iVxC4EWxWB+3RKN6OTDXOc4fX?=
 =?us-ascii?Q?Xpa+RIWntw3L1QSczd7omiItHMKAh6YN2SXDCb2x+tsw6IOVIzoaZkwFC4sC?=
 =?us-ascii?Q?+4DKvk+eI6lZyRQySrx0CKoRoUIwZ52uimAipz9M5WhuSS5/jy1xAVqIoG1t?=
 =?us-ascii?Q?ICj9Ew57bUa8MSHaPgV2ftFP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2918e834-9f3b-4981-fb7f-08d968e0a58f
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 22:27:11.0679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ppNGfaa1oaiuy+Cc8w+oPOiSujy4dNP9bYF7RQwuG2D9Uc6ftWY+eKmEYUMswTyddcdKfL5b9lHmJqJa7aQseg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4293
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These patches implement SEV-SNP along with CPUID enforcement support for QEMU,
and are also available at:

  https://github.com/mdroth/qemu/commits/snp-rfc-v2-upstream

They are based on the initial RFC submitted by Brijesh:

  https://lore.kernel.org/qemu-devel/20210722000259.ykepl7t6ptua7im5@amd.com/T/

Changes since RFC v1:

 - rebased onto latest master
 - drop SNP config file in favor of a new 'sev-snp-guest' object where all
   SNP-related params are passed as strings/integers via command-line
 - report specific error if BIOS reports invalid address/len for
   reserved/pre-validated regions (Connor)
 - use Range helpers for handling validated region overlaps (Dave)
 - simplify error handling in sev_snp_launch_start, and report the correct
   return code when handling LAUNCH_START failures (Dov)
 - add SEV-SNP bit to CPUID 0x8000001f when SNP enabled
 - updated query-sev to handle differences between SEV and SEV-SNP
 - updated to work against v5 of SEV-SNP host kernel / hypervisor patches

Overview
--------

SEV-SNP builds upon existing SEV and SEV-ES functionality while adding
new hardware-based memory protections. SEV-SNP adds strong memory integrity
protection to help prevent malicious hypervisor-based attacks like data
replay, memory re-mapping and more in order to create an isolated memory
encryption environment.

This series depends on the following patches to support SEV-SNP in Linux
kernel and OVMF:

  guest kernel (v5, part 1):
  https://lore.kernel.org/kvm/20210820151933.22401-1-brijesh.singh@amd.com/T/
  
  host kernel (v5, part 2):
  https://lore.kernel.org/lkml/20210820155918.7518-1-brijesh.singh@amd.com/
  
  OVMF (v5):
  https://edk2.groups.io/g/devel/message/77335?p=,,,20,0,0,0::Created,,posterid%3A5969970,20,2,20,83891508

The Qemu patches uses the command id added by the SEV-SNP hypervisor
patches to bootstrap the SEV-SNP VMs.

Additional resources
--------------------
SEV-SNP whitepaper
https://www.amd.com/system/files/TechDocs/SEV-SNP-strengthening-vm-isolation-with-integrity-protection-and-more.pdf

APM 2: https://www.amd.com/system/files/TechDocs/24593.pdf (section 15.36)

GHCB spec:
https://developer.amd.com/wp-content/resources/56421.pdf

SEV-SNP firmware specification:
https://www.amd.com/system/files/TechDocs/56860.pdf

----------------------------------------------------------------
Brijesh Singh (6):
      linux-header: add the SNP specific command
      i386/sev: introduce 'sev-snp-guest' object
      i386/sev: initialize SNP context
      i386/sev: add the SNP launch start context
      i386/sev: add support to encrypt BIOS when SEV-SNP is enabled
      i386/sev: populate secrets and cpuid page and finalize the SNP launch

Michael Roth (6):
      i386/sev: introduce "sev-common" type to encapsulate common SEV state
      target/i386: set SEV-SNP CPUID bit when SNP enabled
      target/i386: allow versioned CPUs to specify new cache_info
      target/i386: add new EPYC CPU versions with updated cache_info
      i386/sev: sev-snp: add support for CPUID validation
      i386/sev: update query-sev QAPI format to handle SEV-SNP

 docs/amd-memory-encryption.txt |  77 +++-
 hw/i386/pc_sysfw.c             |   7 +-
 include/sysemu/sev.h           |   2 +-
 linux-headers/linux/kvm.h      |  50 +++
 qapi/misc-target.json          |  71 ++-
 qapi/qom.json                  |  94 +++-
 target/i386/cpu.c              | 221 ++++++++-
 target/i386/monitor.c          |  29 +-
 target/i386/sev-stub.c         |   8 +-
 target/i386/sev.c              | 989 +++++++++++++++++++++++++++++++++++------
 target/i386/sev_i386.h         |   4 +
 target/i386/trace-events       |   4 +
 12 files changed, 1374 insertions(+), 182 deletions(-)


