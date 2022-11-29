Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D04B63C939
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235494AbiK2U3u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:29:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233743AbiK2U3s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:29:48 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2062.outbound.protection.outlook.com [40.107.212.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8706317C
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:29:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a992TBV6R4Aw9ck3ub7NRchaXHU2CR8en+HZDtI1xnfNEiLo+AZOmXL1CxX0AVo9I4SRlDmgVFCvYGw7uf6ib9djgoYterV3UR7pVK23pSxZ7TTvrryOO1BvdO6mJ7IkI5MI9h0A61bMFH06VNVOHod9lDC+GafLBgTnbKlLL2CwAF4q2XNxsJ0xmt38XevP49reb3onahX+tYjoyNm0Q9IvY+A5tlC6pVtZWrSbrB5tEB1obLA9JRL8X0FjVdM8vw6S0W4esAKvvZy+bflkWQyyC1N6z9DliPeWgk+2SE98ZxkTEJp6qxNhgmWxV021HJtKAiR75muht34wO2NhFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fg/y5XOISbY7aMh5HOd5Q23eYMEF5jQCaqyUIS5HYoo=;
 b=e1ka9eLxKgDZRZwLe5smU3V0/fAyr4tivUhmS8z4/wr/8SzaSs4OpDLcbpJmShKOu75DSMiNlXXXM+9fFL/SkJMGtK3waSMF4TPMXZ4AThuqWYxb7cLD3ftt6IbAwEIYhx1zGMyw5EgNixs9fSxZzmyzAiHZslEyU9iqfkcfIbRnMkTs2qRHnifjwfj12e7vpvyT+csdJcvR1KxEA5t4dNxBFGBSdGHhqS8Kvj012VJl305EOWUrxznyboA7bQXcPMsd9MseILdnX4Qb7zFkTOsXzra6syAh6LUiOpVCl9V51M8Bnl25ggG4m+9M8LOXiXCSqNgObrTLOU1h9Ed8Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fg/y5XOISbY7aMh5HOd5Q23eYMEF5jQCaqyUIS5HYoo=;
 b=bT3oXseie+Su9MS09YN+LtlYmbYDUP4T94L6iq3AJm6SnzuKnSflaPvvDFnZfShPUUrz78/HGRDz5ilc5ZKKC7JQmWnoJlfQY6nsWOy9PLT+XSdPbEpOboDHjTakGHwvAEipSBFiS5ajm/EGTCDRpz01nBr0EgLli6Yn7IpnYnzFKm5mOU9FmP9tVcCjIdzyVCxGQwPfB2n0mPeB8o3RgCSjCJLKbmuwQQpBug6kcrCCP8l1Db58hwSoZIUKjofyJz7lMlB4MwU5T9O4U2VKB4g7HmJq6Us1NISCpp6fokoiAnoK+jaT4ZXsvwIAspHVFgRYE2yeozLwmh+V5nBUmA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB6059.namprd12.prod.outlook.com (2603:10b6:930:2c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 20:29:45 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 20:29:44 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Anthony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH v6 04/19] scripts/kernel-doc: support EXPORT_SYMBOL_NS_GPL() with -export
Date:   Tue, 29 Nov 2022 16:29:27 -0400
Message-Id: <4-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0110.namprd05.prod.outlook.com
 (2603:10b6:a03:334::25) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB6059:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e28e870-7493-4b31-b76d-08dad24873ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3DyvJO2b7GG2hk6oE+OIyVb0g09XYn7vVngo1+/D57f1COZsje1sqmkALk2rO2wTmt21y5YOVyrX8lPmTjGk1hb4a6NUdd8xqH/xOUoCNhNipIahR8JdXQWtq372SKYIIljIrfKvjcSY1LTchCuL8HckfvFUXbTcS7xsxRAuiVQKZCa2bWV532q2muejjFXl/76UmWjCWnUOBBC3FWiUGheMEc8cdsngcgYJth5EWKHCqYo8IeEOc2hszFf9wH8ESg+aRXn5i1NLw+FuYfVR6WUwVbSXZhPCESFaF5GvxlC0jAjriFGyLtQy0C0mRc7WkFbnBY95VtsYlSf5M47ZW2TwBaDWLecf3xMAz8yCVlhbpbwrqw9UEp4a+6nATSNWKw/6ZI3DQkJ0TAYHa+U2rB5wlWwuboMZdpr++ACBMkYUpvM4VapH6qdxCUwRMSnYTkr8TLdJxR/y4nEjkMak3Wx8Hp0nHeidLBRUmHLRjYPGdk8we4Q3l8Vin5QdE+qdOdlDFBM/V/oJM3gUw0Q3GYpgO3jfiLwQ0k3DHsAsVTclUBFW9rztbr3lIGWz3yecoKOsVOyxKmSe31DzleTrqWAwl8Pyp5dGcuf8pqeAMUl+lb5uA4zzk6Ak4mKpVhFjflbWDNNeOguMOjoF/cs8XbavZKTdqWbKPew2QgSxheRisbz5NRmQULPy8J8oT+Y2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(451199015)(109986013)(36756003)(86362001)(54906003)(6486002)(316002)(478600001)(2906002)(66476007)(66556008)(66946007)(4326008)(8936002)(7416002)(41300700001)(8676002)(5660300002)(83380400001)(38100700002)(26005)(6506007)(6666004)(6512007)(186003)(2616005)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bsggVvTFDaDX6xvHcE073mX/evaI8PffvSvKwfViVq6lkNzTs/Y5KjOP//Cl?=
 =?us-ascii?Q?4Mb7At4T3PSgvXpgrK+9SnxCTfTy/D9jMmVFjzaD17XM1kUVu1UIczq8a1z+?=
 =?us-ascii?Q?Efj56Iy1HNu0c07GCH6Q84tDXcVSvwP0xo6JBmmkrxJu9S9VOKXFj6kui1/t?=
 =?us-ascii?Q?OVPJkfmRhLufO6LysvcS7ykotmWxfkac1llJyhwyCgsQ6jXFE1le9JjgkkUh?=
 =?us-ascii?Q?W2CrNCBVwCRjLuZo+QGfJP1X078884JgpvIQTnx9iykx5+h52UgWcABDNiCT?=
 =?us-ascii?Q?uzfXngeLkB3on7Nt1AO/pO8MySfxAP650oL6h5n17WIzsvQ8yFWlLpz7UnQk?=
 =?us-ascii?Q?vEtBC1b1SS9O9Ewx6eMa1qxNlLVvLM56w4HbTVpreuNyoXnL5UySBmQcQC9D?=
 =?us-ascii?Q?C4l8xvp+emj7qVUqoohr+1fdSkceJK2t/XEGkxSPL6rF4JsZFAas+vpqqp1u?=
 =?us-ascii?Q?lXvNurAuuZhke6lJoWP3nBiNDyDCQbb/VQUUnUzfv2F6HIrrEthT08C3FOKo?=
 =?us-ascii?Q?6nXrrnz4PD0M3i4ZgzlBVGZ4D1JYUv4qbw/FYExhF319eyYFPgRfL0KqquUW?=
 =?us-ascii?Q?pWjMKxxvx0jfN1/t4vPrcIFth7rkAndjZnjhMIE8hCEoOknB9M6FQ3QKiaN9?=
 =?us-ascii?Q?ED0ZR8vH8S7DdpWtWBOedoll4IwbeIm95u2o4yHmpxYaylz4IIRmHTSo1360?=
 =?us-ascii?Q?xMQwp/Bxr96r9cul5WIRd+i4g+7q3Sqee4sMe+2uzplIwmS5xBez2ml1jA4h?=
 =?us-ascii?Q?1gXEGaa4oXaDezl9Nk0wPdCPCCNl1Ouhqp5wedDqsDD3e/hWmLukge1Kd3Iu?=
 =?us-ascii?Q?LZRpJ2HzZFNpjBHpcF69a/V82cXE7sgpUIWxmOn95zuNt6irsaPYhlDL2U44?=
 =?us-ascii?Q?W8KTXtw+nM7KJVXnmCFgb1TJh5GvwbfpU9f2vQDeDJGeDOLcQ++PUorWgMDs?=
 =?us-ascii?Q?p/0q73I7yKUj5oUvSGYmtnxBRb73JJvW10+3Y7i1aPO3qzQ5sBDB3lk0SEdQ?=
 =?us-ascii?Q?mUp4nRs+GX1veBgRv7siAkAOSonoi937k0UEdV2ETSQ/PdQxShxCzwzVRJmv?=
 =?us-ascii?Q?4usvYPPVBrYgs4wIxUSY7kvmSzwHJ75jJeKMY0VLN8kUrS5wNdANj4QzbXqM?=
 =?us-ascii?Q?BV3nQSMgjuT0ds4YKgzF2gxdgkgE1gdhtHf7qFQFG0ONf1bD8fXyF88iil8K?=
 =?us-ascii?Q?KFjW+kqWQK57gkoMwqC+FF71x1hn0NUHPODJq+WClTlB+vWvrI4VWn5a8iqy?=
 =?us-ascii?Q?ivRXz2sVkfJle67Mwlg/BC57zoHLu/uTvdZWEg3xX3TLcC6T818LSouOhUo0?=
 =?us-ascii?Q?IPfXWsqr3pWrXnZ5uRFo60TLQcXTh5UXAeZrfgELZxfg+XYXQvggouMH3sFT?=
 =?us-ascii?Q?nbrep0vNvzZexNl8xJtO0t5y485ESwbx3DJxUmGofwgZoYP6zVY8Lg0QMy0Z?=
 =?us-ascii?Q?WDzUhCpz4QvMM9kO/UG+dODusIkUBTLFpi5P3XzK1MJjj13DvKavc5hZ0fMa?=
 =?us-ascii?Q?i46wXIBKZkh/2SRusPvOxyprU/vBHCCdnxSsxRdb4a+K662w0qVkMX8Iw8+2?=
 =?us-ascii?Q?KIR6sw3ZTZXOZfos8WQy955dMgnMts5ix/SP6JIs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e28e870-7493-4b31-b76d-08dad24873ae
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 20:29:44.8998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JLTBbd3wXgT1WMyAJBWMQDaPR5e6KA0ev2EgDXde5AGhBHhSzyWX5XewJqkaNxPH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6059
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Parse EXPORT_SYMBOL_NS_GPL() in addition to EXPORT_SYMBOL_GPL() for use
with the -export flag.

Acked-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 scripts/kernel-doc | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index aea04365bc69d3..48e3feca31701a 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -256,6 +256,7 @@ my $doc_inline_sect = '\s*\*\s*(@\s*[\w][\w\.]*\s*):(.*)';
 my $doc_inline_end = '^\s*\*/\s*$';
 my $doc_inline_oneline = '^\s*/\*\*\s*(@[\w\s]+):\s*(.*)\s*\*/\s*$';
 my $export_symbol = '^\s*EXPORT_SYMBOL(_GPL)?\s*\(\s*(\w+)\s*\)\s*;';
+my $export_symbol_ns = '^\s*EXPORT_SYMBOL_NS(_GPL)?\s*\(\s*(\w+)\s*,\s*\w+\)\s*;';
 my $function_pointer = qr{([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)};
 my $attribute = qr{__attribute__\s*\(\([a-z0-9,_\*\s\(\)]*\)\)}i;
 
@@ -1948,6 +1949,10 @@ sub process_export_file($) {
 	    next if (defined($nosymbol_table{$2}));
 	    $function_table{$2} = 1;
 	}
+	if (/$export_symbol_ns/) {
+	    next if (defined($nosymbol_table{$2}));
+	    $function_table{$2} = 1;
+	}
     }
 
     close(IN);
@@ -2419,12 +2424,12 @@ found on PATH.
 =item -export
 
 Only output documentation for the symbols that have been exported using
-EXPORT_SYMBOL() or EXPORT_SYMBOL_GPL() in any input FILE or -export-file FILE.
+EXPORT_SYMBOL() and related macros in any input FILE or -export-file FILE.
 
 =item -internal
 
 Only output documentation for the symbols that have NOT been exported using
-EXPORT_SYMBOL() or EXPORT_SYMBOL_GPL() in any input FILE or -export-file FILE.
+EXPORT_SYMBOL() and related macros in any input FILE or -export-file FILE.
 
 =item -function NAME
 
@@ -2451,8 +2456,7 @@ Do not output DOC: sections.
 
 =item -export-file FILE
 
-Specify an additional FILE in which to look for EXPORT_SYMBOL() and
-EXPORT_SYMBOL_GPL().
+Specify an additional FILE in which to look for EXPORT_SYMBOL information.
 
 To be used with -export or -internal.
 
-- 
2.38.1

