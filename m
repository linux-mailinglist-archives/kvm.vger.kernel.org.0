Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E88F5A6449
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 15:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbiH3NBi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 09:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiH3NBd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 09:01:33 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2086.outbound.protection.outlook.com [40.107.244.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16004BD37;
        Tue, 30 Aug 2022 06:01:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QIaM5GPcW/6NUizh6PZTajSa3MaQalKulUnGaO3KUFWsYckidYFuESQcr3R5mmnxhTBvar47rw4WGH1ggb8+QJP0TvdiFmW4Q2K0avc8OgU+AU33p8hSXn7eDJxm9U7nxj0i6O1es805SZ9Jf3SrQ3wz+H2frYzlmABDXkCSkC+jWMvU3vrecMARHf9wY+oTQ37INi441I9JMpfluSLDu+TNatSeSV+sBXtuOD5HVcrU+X0SVVYK4FPSRwxUEu0hfGqcEg2eLKz6t3GBykjGthptwb25fAcAVz1vLQdZTZ/0QXFqppPcyLrYjukb86A/A2iX/59rtVLxrik9uIVxRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mjKudDZNgLYgc4XBq5aYSAELlvltGk3PSjasQQS1prE=;
 b=cPdsJYXCjPG+6WLid/7RdtlJeOdDYnUK0xGdU0D+hNfGJIg/mhaiti6We3rQhI4qihQoU/ChVUc/3BiBAuetXKKxnI+bjzMNge6c9DbowSIaEYLpQnjqR8Brq1ntTJJPcD+5dzxJdMi+/XcNRnfLw6ZDvkmT2iF1QFv9dRdtEXTV3Xh5Z/9QoBFEeRDa1AV1mlw18ytQY/VTDORkjPZRFazEQLPW+pYqaQfPR6qTZxP29nh8T0LNYDwCvbnIyXrs4OG0Nw8m9rRcBd79txb3kkfFkjDoQ0yXOeZM5uq+xPHRruAOmNGQz6FDO5sDu4EaL4sLQ92QOzxgBJmnbGWHHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mjKudDZNgLYgc4XBq5aYSAELlvltGk3PSjasQQS1prE=;
 b=BfqhkpKdVc51DwiWe4/PCjZ57gDjp4X0ZMP/nc7TSUhI9FyX+45ueT/bvU89M+QEggW8wNKXsx91TUEtAhui2eHQPx4TK4UEFXBEM+jkpgV5SjASaek3iP5ud6vIK+0ftfa00U2YPvSx+u7QdsTLc3ixnRpsz6UxF9eQ9rbbytdBNKoTBGfXQmo/WkMTg0TqcKP8bPtIMIw3NwRHttC00ZzoaCanjFjPT3APRmTi3LI9UEAPJr/RT3sUKluXRm0S4/1UtmzoZG48YpUCuRwX02UU70GwixBfiNaSv3zlRNxZui4pMRtGlwVl1PxodxpjffgI85HmAPmF254aJHhH3w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SN6PR12MB5695.namprd12.prod.outlook.com (2603:10b6:805:e1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16; Tue, 30 Aug
 2022 13:01:31 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 13:01:30 +0000
Date:   Tue, 30 Aug 2022 10:01:29 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Gupta, Nipun" <Nipun.Gupta@amd.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Saravana Kannan <saravanak@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Gupta, Puneet (DCG-ENG)" <puneet.gupta@amd.com>,
        "song.bao.hua@hisilicon.com" <song.bao.hua@hisilicon.com>,
        "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jeffrey.l.hugo@gmail.com" <jeffrey.l.hugo@gmail.com>,
        "Michael.Srba@seznam.cz" <Michael.Srba@seznam.cz>,
        "mani@kernel.org" <mani@kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "okaya@kernel.org" <okaya@kernel.org>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: Re: [RFC PATCH v2 2/6] bus/cdx: add the cdx bus driver
Message-ID: <Yw4KKWIGsR8MKa1j@nvidia.com>
References: <DM6PR12MB3082D966CFC0FA1C2148D8FAE8719@DM6PR12MB3082.namprd12.prod.outlook.com>
 <YwOEv6107RfU5p+H@kroah.com>
 <DM6PR12MB3082B4BDD39632264E7532B8E8739@DM6PR12MB3082.namprd12.prod.outlook.com>
 <YwYVhJCSAuYcgj1/@kroah.com>
 <20220824233122.GA4068@nvidia.com>
 <CAGETcx846Pomh_DUToncbaOivHMhHrdt-MTVYqkfLUKvM8b=6w@mail.gmail.com>
 <a6ca5a5a-8424-c953-6f76-c9212db88485@arm.com>
 <DM6PR12MB30824C5129A7251C589F1461E8769@DM6PR12MB3082.namprd12.prod.outlook.com>
 <Ywzb4RmbgbnQYTIl@nvidia.com>
 <MN2PR12MB30870CE2759A9ABE652FAFD8E8799@MN2PR12MB3087.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR12MB30870CE2759A9ABE652FAFD8E8799@MN2PR12MB3087.namprd12.prod.outlook.com>
X-ClientProxiedBy: MN2PR11CA0019.namprd11.prod.outlook.com
 (2603:10b6:208:23b::24) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5a89d7e-2843-4c8e-a920-08da8a87c1e8
X-MS-TrafficTypeDiagnostic: SN6PR12MB5695:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y55oKkr+jlDAzkPF+xSExS+0seYaAwbmAFvrr5BsQIS401oTO8WnytRmtiVq2woBBhziqWbOUAXT5pM1dBwmC8R4JFtO/B1pWbLaMqSOI5MfC2s+FOvKoXbjXAlyRRT7sPVbc/P7XyatXb5hRJcERFvpoKHJaON70Y7Y/xNN4Iv35KO7C82I2vUlM0m9PY3Xyc/KlvsDvxx8i0ERJq6wQJr8DUhK3fC9CLlPdUBtRuHEcPW9mXAyWFgxUFPjDJyXoLeOjcL/0GcJSYjJf42UAJ/mPmU3JzYy4UFnRLg357yTNxFKZeYyAWfn+2iovaHHBnSXEoqmHzQrVvk1RxF3g2izrkqKaYXHU2C2sTURD7NFCuw2/fO2cNk5b3ohuRSFkDpWuII7RT+yE+ITixRhQvuaWNsd5qEYu1yOeypOxGHovKvqn1k0ClDDFkSLV2RJzCGRLK3/6wqrNc2yhIL0cPf/vS+YcRcuZNt5Ef8y9QokjIC+AY8A73LV/xmRRA2lSjsZVXQpsWZ0u4+xLWYcOviuVdXbRafKtn+sBNxkAtTQUIkhLR1mJ5BGiT56wLh6FtLjt9i6STBIzvsuv7bevzzrXCsfXxDb7nuMZkqKyScNCf6l53BX+4rR/HWeR0wB85bC1nJMlIn1z32lQCVXy512vzstWq9A3OrhEls49+eDvLZY320oEfp/FeQrj9nLvZiywwO3ZuAAUoSMrxtz0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(346002)(376002)(39860400002)(396003)(478600001)(6916009)(316002)(8676002)(6486002)(86362001)(66946007)(66476007)(4326008)(54906003)(66556008)(5660300002)(36756003)(8936002)(41300700001)(7416002)(2616005)(38100700002)(6506007)(2906002)(53546011)(83380400001)(6512007)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nrkx/LzMITkZLq75K4KfvuwxGBq9tPBEyIwBP5J43ir0XCpDNVHNA+fAPukx?=
 =?us-ascii?Q?z/bwBgHdMyZfs/+nVY/f7Fp6NFEGdjBoM/E1q/S7qkMpqre0/h7ls/1SXBOl?=
 =?us-ascii?Q?0OYqZWrLdhAnRaHyEGVgq36RrQnDXL+/bR30Kj4lXKg+eKqlakrCans7ZhhG?=
 =?us-ascii?Q?huPpR2X4BRcenSu9vDlJUwbckWiiY2xM5fUuvzjYFN+VzaVGqU95nN4DBCdl?=
 =?us-ascii?Q?AE14dTn6c67cKVOyASd37JyMBaHkT6xaRbvZk+nS/74rhnFeyPJZyQwCjvan?=
 =?us-ascii?Q?Z/fDILdlddlIHzrEVV2VyXve11TelViAai+qGjaUM9FDBqbWy/W7/TrqI+io?=
 =?us-ascii?Q?73LjT0t+M+Ofc9Azs7bFVcMlla46OwjscuKA4ZtF3nyA02oGJs5tOXS8wpfO?=
 =?us-ascii?Q?uC0CeOFL54Q09e9uGU6IEWtcnM0tLUkhoSSO2LZDhYnseR289KQELVV7p4F5?=
 =?us-ascii?Q?6aNukUFLDxexOConpjSlpR/PE2XVYIdFQLk34vag8RBOZHtUXxCJovmrs/t4?=
 =?us-ascii?Q?HsCB1EehgX9QcZzKJJW8pYjhY2WRV2VM+Ta6cG4q4vpnukce22qCR9NkWy6D?=
 =?us-ascii?Q?ynabWS0GfT2wri+983lMuTKcL/4wRExrlHrMqNX59A1MbgR2ikzmwKDLj+zv?=
 =?us-ascii?Q?vJZXNvX3Tz+6axvlFb7FnryCd5vVzDemhaWFbTXqYtWF1ElJvUFvojdWv1Ai?=
 =?us-ascii?Q?mxg/U8q5fz3+o71YI5OcjIUK2S3ZmBOHqt4luzOjs4PPyC05Lgp+y/gqHN/o?=
 =?us-ascii?Q?dtOaojmgucM/LWBv8H3QAR6mlePchKLtpyywPZvf3epXqhDmGpCoW3rO7jF8?=
 =?us-ascii?Q?pf2L3NR9m6scvEem0EVLRccC3KYZtritdgvhvrRjZHt5JnKGAcakzbwvWsGO?=
 =?us-ascii?Q?WIg451ojS+jIPmQCE+dpaKsnhyLNrhe+1/klrGqeb/u6O4Ae1ylGwxrYh+kh?=
 =?us-ascii?Q?7USjwpNlpgOy1qlOWQS4vq/vINTnMQSPhRiSd3FwlHvDjYzZrpBnBC5l3E6l?=
 =?us-ascii?Q?/QEsZA7zNb/a3ijQAtqAlF40yAYJrJQZ8GDQvst2Ro68utMRc8XQEFc0QAnZ?=
 =?us-ascii?Q?2DHLkj88PZ4ST8C3pTnXkXsA2iZKyLWzdVBat59lingaT/362mVmOo1ekJdh?=
 =?us-ascii?Q?JPZzRTsS9H/QTUA2AnjwD1E18ENrHn2Xkr0Rn3F2VMOiHjhvfgMZfJ0HyuxS?=
 =?us-ascii?Q?99d4cfq3qZ7I/ZkQoJCxbhdc/dtCn7rWWrgh//jl/JpM4c/+KUelDJePpq4W?=
 =?us-ascii?Q?vSJbZQtIero9GLgRvEPh+w5PqXXOncp9QFUPUd9XU9U6jWeskc5t4ShYZDvz?=
 =?us-ascii?Q?+YIBqaKodXGpE5ubzbFp3Tb9c+t2ux57wnRGJ7jMAv/qc/+cq2T/bR7yx8G0?=
 =?us-ascii?Q?uE1SSjW3Rzi8/W3ZUfDgCxBRc+lexyQmr0t1Nwep7PK9snMWzM7vwhlLaOd+?=
 =?us-ascii?Q?ZPDDmQEwqN6/3E/r48zcYJXDleCNbMB8CFnyl3+0Y2C1Y7YMaWXUidyUBbRT?=
 =?us-ascii?Q?4TcnC5mJIJtzri1zg5vlhlF2Vs+mPIdv2R3xNJi4ORFHiG5QeuLp0Ox3dz/i?=
 =?us-ascii?Q?r/GPx6xb5l8+uMfp2C2WYX2uOwjRNdtRX92mEjyx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5a89d7e-2843-4c8e-a920-08da8a87c1e8
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 13:01:30.7158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9vjjT/nmZj32NcF7kuHwGGKn7RxUSMAgtj7ZYeadAiJwRet51xglW0loQxEngVmF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB5695
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 30, 2022 at 07:06:12AM +0000, Gupta, Nipun wrote:
> [AMD Official Use Only - General]
> 
> 
> 
> > -----Original Message-----
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Monday, August 29, 2022 9:02 PM
> > To: Gupta, Nipun <Nipun.Gupta@amd.com>
> > Cc: Robin Murphy <robin.murphy@arm.com>; Saravana Kannan
> > <saravanak@google.com>; Greg KH <gregkh@linuxfoundation.org>;
> > robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org; rafael@kernel.org;
> > eric.auger@redhat.com; alex.williamson@redhat.com; cohuck@redhat.com;
> > Gupta, Puneet (DCG-ENG) <puneet.gupta@amd.com>;
> > song.bao.hua@hisilicon.com; mchehab+huawei@kernel.org;
> > maz@kernel.org; f.fainelli@gmail.com; jeffrey.l.hugo@gmail.com;
> > Michael.Srba@seznam.cz; mani@kernel.org; yishaih@nvidia.com; linux-
> > kernel@vger.kernel.org; devicetree@vger.kernel.org; kvm@vger.kernel.org;
> > okaya@kernel.org; Anand, Harpreet <harpreet.anand@amd.com>; Agarwal,
> > Nikhil <nikhil.agarwal@amd.com>; Simek, Michal <michal.simek@amd.com>;
> > git (AMD-Xilinx) <git@amd.com>
> > Subject: Re: [RFC PATCH v2 2/6] bus/cdx: add the cdx bus driver
> > 
> > [CAUTION: External Email]
> > 
> > On Mon, Aug 29, 2022 at 04:49:02AM +0000, Gupta, Nipun wrote:
> > 
> > > Devices are created in FPFGA with a CDX wrapper, and CDX
> > controller(firmware)
> > > reads that CDX wrapper to find out new devices. Host driver then interacts
> > with
> > > firmware to find newly discovered devices. This bus aligns with PCI
> > infrastructure.
> > > It happens to be an embedded interface as opposed to off-chip
> > connection.
> > 
> > Why do you need an FW in all of this?
> > 
> > And why do you need DT at all?
> 
> We need DT to describe the CDX controller only, similar to
> how PCI controller is described in DT. PCI devices are
> never enumerated in DT. All children are to be dynamically
> discovered. 
> 
> Children devices do not require DT as they will be discovered
> by the bus driver.
> 
> Like PCI controller talks to PCI device over PCI spec defined channel,
> we need CDX controller to talk to CDX device over a custom
> defined (FW managed) channel.

It would be alot clearer to see a rfc cdx driver that doesn't have all
the dt,fwnode,of stuff in it and works like PCI does, with a custom
matcher and custom properies instead of trying to co-opt the DT things:

Eg stuff like this make it look like you are building DT nodes:

+	struct property_entry port_props[] = {
+		PROPERTY_ENTRY_STRING("compatible",
+			dev_types[dev_params->dev_type_idx].compat),
+		{ }

+			ret = of_map_id(np, req_id, "iommu-map", "iommu-map-mask",
+					NULL, &dev_params.stream_id);

I still don't understand why FW would be involved, we usually don't
involve FW for PCI..

Jason
