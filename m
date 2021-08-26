Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D173F90BD
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 01:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243818AbhHZW2T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 18:28:19 -0400
Received: from mail-mw2nam12hn2244.outbound.protection.outlook.com ([52.100.167.244]:22624
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243821AbhHZW2S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 18:28:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cctLzdmHPqutwuAvujwXr1xq2G5SOsxS7dHbQs4NfQt1uGuJxCnOCNmHWmE2KMCTwOcp7SAE3jXn1jaB/KJYmRiPk7efM3qCs+NlWdy6vSCoN7oBF7NImdzy3HyoF+ledeab2Sm1crZBbqjZe2ZdjmTCmkr2H4ssGnFKiJU2fdCD0Aw5wLuSRS+LT1P5I0qpYDGjINem9nB9alwGFKO8QLoiIDFHUbtZ86mGeiP2+S32j6+QSTte5zyLMEpLsY1q6Zntfoe9h3FCdqx8AWoGRgCiPt3iDkVOLrHZaC7C8JCh5dCosbnenZG2kW1f3j7BuU4NRj0+CCw3zTGmVg4vaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oCIF4V+DyRUxL1XZ+BPubHZ0R8xCProyq9AHNkHqtqQ=;
 b=FvPrm/KIn21bzMatgDLdxyVAwF2pz6auc/OXSeuOXqF/wLsmzyqc34UfsGBK/NKWTzNP9tZcZ4kI/OQVMNxSSHwVaODhVECwKwISE2RVsTC8dl6Sf0zlIjHjQFtlbJVirqIXkXagfObmfwSDdUjg10xivYDf6Cr/ReXa7EewR5HnJ0ZdwiKVce4JK77kjL1Hu3cJ5esigpoAooev6xWCOYcjdHGiyp9DUs+dPgX56n3XbM74HKu9Z2tY/fNO8H29M94V0baYZ62L8CUcQp/zdtkcRLpbCV/OP55Z4PQBoU3YgckUHwdK9eMGDr+gobf7/kNfybdddYBQVPOWqyKtrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oCIF4V+DyRUxL1XZ+BPubHZ0R8xCProyq9AHNkHqtqQ=;
 b=JU0MTIbmGjFQFcveFTTUEGs7TDjIRgdNudjFiVALTd6dMzkgi9Vd6onbBFN5lgiROelrxDml6vDzZrPLoQAywXtXUwEVo/YFD4GkN5bGept2UEKP+Hk6bKYi1Ermw/FRViAvlh6G79Exasy7sTXkPPL5Y9icFRqCFAfE6VT7TX4=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB3925.namprd12.prod.outlook.com (2603:10b6:610:21::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Thu, 26 Aug
 2021 22:27:29 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::d19e:b657:5259:24d0]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::d19e:b657:5259:24d0%8]) with mapi id 15.20.4436.019; Thu, 26 Aug 2021
 22:27:29 +0000
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
Subject: [RFC PATCH v2 08/12] target/i386: set SEV-SNP CPUID bit when SNP enabled
Date:   Thu, 26 Aug 2021 17:26:23 -0500
Message-Id: <20210826222627.3556-9-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210826222627.3556-1-michael.roth@amd.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0074.namprd11.prod.outlook.com
 (2603:10b6:806:d2::19) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.77.1) by SA0PR11CA0074.namprd11.prod.outlook.com (2603:10b6:806:d2::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Thu, 26 Aug 2021 22:27:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8e7c910-bed2-47d5-9a28-08d968e0b04d
X-MS-TrafficTypeDiagnostic: CH2PR12MB3925:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB39256DB8C5D8B0385E58197695C79@CH2PR12MB3925.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:457;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?l0feJavaDRTD3cHM4oON3A1yhbggufivrmAVlgCQ1sgvadJT5HcZ/4gT1T+J?=
 =?us-ascii?Q?Qe9GcTWSoX0Rx8RnmI6kdTZ7N91CjHhllh1MRHua8n4ubofV6NCxuhR4txJl?=
 =?us-ascii?Q?c8FfwLNGDk0qbFW/Smah/3JVDMIUenqLowFlyi+5F+xLk5O8/kX6G0+B5gCf?=
 =?us-ascii?Q?VD3RhZoQy/gluz+oBSonDheYuXVxMwTXXQv0YMxFcOKySnBJysg+jjNL9l8u?=
 =?us-ascii?Q?rWaqSxXf/qFhz4cP6NrwbEWcbeaIQBXxo/JFKFbnXe2wNZBULrAbBSyEVk/T?=
 =?us-ascii?Q?hNOoMIZyF8Z5g4FBKbW1I2Bun5Ep1jJDb5gXDyGK6GwIVDt9IityD6F1rgNw?=
 =?us-ascii?Q?9xrlihhNj/2wso44eSm0SNBWDvp1FQtIspKlQB3VKFMsmGvvaEjO7pYC4ej5?=
 =?us-ascii?Q?NnnpRaHMzsLh4YR/jHe6YohtDZQFGWcY0a00k9K4D1lqgM/NxQQdVfSlPM5C?=
 =?us-ascii?Q?FCl+uL1LS1dDn962nZVLTtEWUPX5/gARM6Gw6+mnZP51Bq1OddQ1hawHX9Xt?=
 =?us-ascii?Q?BIMjRuJGikveceLMkpJ3YDObrkIuFPHDAKDRE4MsU3y6qNjlK3ppHeOUTGR4?=
 =?us-ascii?Q?PbDFHg/sqONM0T+yY1DNTBDidfMX6TzP7jiA5Ug1jLxcf6Zv1wY/9pTTwwlo?=
 =?us-ascii?Q?fxVGhEa6DHoXau6XS1w6+ArKNGSY2Vb16O5NzS4GJTpL5cs5SXIPhxhxIOjn?=
 =?us-ascii?Q?Ry9XZC2mHQSmHQu3tOaZ3SJnXKWRuA6gFhusEMU9vu4hBwEvJVWPH6R7KYs5?=
 =?us-ascii?Q?LRHvMgaEE8J94pyzlZC/P5DfpBxOWPRc6KLtwNDl0nk98SWhqwxuy6CBXwIy?=
 =?us-ascii?Q?7rrqbMfjnjasQp9XjuTrePZuFKYVhH9/sM1qmyPTNEqnFVRKsfVp4qN0Iwqs?=
 =?us-ascii?Q?n2p1oxSGFKxAG2vCm3oG48Fq0rGVFXZ5Va7oJd1vFzxsOdQLoWQD1FpSZt3C?=
 =?us-ascii?Q?qCt/VEE6W1oZXHKcRCx2jN/5+se/Y5iTipJx6oY7aqPdGCp44Hkagw3B3k++?=
 =?us-ascii?Q?5TFF8zhS8Iwao1VJYDLXbZL99L/RcsBVtY0T99U29LaFN9M=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(376002)(396003)(346002)(136003)(39860400002)(366004)(8676002)(38350700002)(66476007)(38100700002)(4744005)(956004)(2616005)(6666004)(66556008)(186003)(6916009)(478600001)(36756003)(316002)(4326008)(44832011)(54906003)(66946007)(52116002)(6496006)(2906002)(86362001)(1076003)(6486002)(5660300002)(7416002)(8936002)(26005)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lJ2V4nvRSN6OwagZwWQFit9e6sMMv4fqbXq4cDTjUlHeyT/ff7/XcEpVA60M?=
 =?us-ascii?Q?rSm12ZbhC/SaFxBUOrewkYF8EvzOG7bwZesox5BDYGg194E0z6A/Wx8K4ulh?=
 =?us-ascii?Q?hW4MiPDOfBjCoCNprNoS6MxbkZTSwPAhK/xwS3+Xs6Q/2xQhwrSHrJ8X704i?=
 =?us-ascii?Q?te/OW1RVF/HUOeFNR/BsAy5miDAZZjIJBbyidEY+yIAb5eeQepaztg0nyjYf?=
 =?us-ascii?Q?bnSifpgvppctBcBrR2ENlAdDQ+sFRmdgR3SHJJRvfRTAsV47dn0GIZCxaevr?=
 =?us-ascii?Q?W+eKsYYQubkbiH50sqMyJ+UX9e+bCrBSQJrabspZT+rzAL5vNorQEQSn7Q+W?=
 =?us-ascii?Q?DndabW/Q0wqHWEk8VUu47YsXpRSQKFvG01jOgJQqOl2yQLZQNCPOepN8iQN1?=
 =?us-ascii?Q?4BLS7NzvJPcZlsBaXpPaHefYBTQBp2sEhWjp46GB8gW8AL64QhqEctmVQpQX?=
 =?us-ascii?Q?76/wRK7aWDprqgS6rlrc2cXgNnp9bLWx73Sgu9DX6RzIHVFetUXQEac9lh4N?=
 =?us-ascii?Q?3c8nKx9VkS1nMaNHhCReBSW/3UGnshKpPAqxg2QcKyJZ4O1QFAEbV+lbfODK?=
 =?us-ascii?Q?01AgluOM7aOhF4eNXDjIjBsgX/sxZHVXc3i81EH6cDhoejv8g+JK7844VkS5?=
 =?us-ascii?Q?CIidIVNJBgaLicMYNrDvQuh6QV0LnYssassuxkBvPiWZvHiUfwgk/TqkOAr4?=
 =?us-ascii?Q?BQbGfJ1dKOfUS2sR5kf9B1amn6BQ5pWqzDvL5LhS9weIQ3L0NximJa+4HOHZ?=
 =?us-ascii?Q?ibh3tZMW6al5u4OdgyrG9ZQl4QKaE2Ep+k7Dw+VXwLM65DsiNiama0CirX8S?=
 =?us-ascii?Q?jfAGT7TR318QMfmhkGi3fcaS61y5dCARs5LHNFvWkXz7wio6mI6cfFKyC5tr?=
 =?us-ascii?Q?Iz9RWPrndBDhfOoJ9ybSCT91ec6GnlyD/dpqfzGgZe9/yfCjpA8baO5vmPtJ?=
 =?us-ascii?Q?hrpJsNLRjY0AwcHZbQYtLBCt8Hjg8cHEVDKbwklhZaXsuDExP2/t75+h2fSz?=
 =?us-ascii?Q?EUvRAT0VTKkCroMm9tLNRPOJRf2aemNDMwCh5gqAzH9s57v7geWZfAzoLj0I?=
 =?us-ascii?Q?detLocQIWeN8pwIdaH721jJDzVcbwehEUpjQizn7XM+ggKD05GJ4rgnmXW3f?=
 =?us-ascii?Q?fY2LpU1+vR8i1D2jFX12oXm830DrglyVL7CWNLoh0y7vrasZaRV6efHvs1L5?=
 =?us-ascii?Q?SsUvx3FDeoKR6Zt0H7KZJrJA3wtOfkFjHdDEVDVXXWrHuTe7bkF0dTDVwqSH?=
 =?us-ascii?Q?xYOgJpnSTBADdnHW3rXyMyc7Q5dhQ+vPcB3RFSf0aeX9qhHV207grKeAa/Hn?=
 =?us-ascii?Q?xAfYTfkxjpi1VgzWhRztHyL4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8e7c910-bed2-47d5-9a28-08d968e0b04d
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 22:27:29.0818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U5Vmw4OJD7jfCj/U2eGwQJbjdzrAX52+EyH7WVFP0lvYgC8V4w/LnjCHSOKi6MwcJD5YCVzk2TfRAo+xCtD9iA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3925
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SNP guests will rely on this bit to determine certain feature support.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 target/i386/cpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 97e250e876..f0b441f692 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5619,6 +5619,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
     case 0x8000001F:
         *eax = sev_enabled() ? 0x2 : 0;
         *eax |= sev_es_enabled() ? 0x8 : 0;
+        *eax |= sev_snp_enabled() ? 0x10 : 0;
         *ebx = sev_get_cbit_position();
         *ebx |= sev_get_reduced_phys_bits() << 6;
         *ecx = 0;
-- 
2.25.1

