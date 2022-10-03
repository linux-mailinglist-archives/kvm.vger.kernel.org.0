Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 010175F35C1
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 20:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiJCSnO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 14:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiJCSnL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 14:43:11 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2048.outbound.protection.outlook.com [40.107.101.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A348F33A3F;
        Mon,  3 Oct 2022 11:43:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JpoN5kTbdCXMnqEcmsig1xVaMe7u6hLvZDyinTOm5uS3uW4XQKcEDgZNYFyRaNluryS7+Xmqby3JcSE63RaDeHQXvPk7KiuKd+wtpyDJ+M2eaFBmzOWxnALk8CtnTw/z8UvcqC9IOov+hgSK3Ka5+Qse104eSM7j+O9zWBEJ4Eon7WD0Lnla4Hatyo5kW8dtpbix8d1DaW+ctEbx1K25O7gGmON5PTg7D4Gxy6DQ8IdtlZnF/GEVqnTEBVprTU8aV/yCXUejGTjBdrk+FQoHf8xAHfbdgS/IGcs9WZ6X+UEHpDAt3qBZQwDlLEXaP6b5J8QI25EM72g4vJPF9WPrvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8QUKkuIlfngvH1eOwyVv/DooDUyodoQgW94eLCdSfZg=;
 b=P/NwtgdRxWqG5bsws245otElSCzuf3JZormrQClExoj5fb6nyBG34Fk8Vul8E1rIuYEsn8t78T+nxmOYHSAt9/p9WeNWmGMyvumh709BLOv0BFpuZqdTZE85JafXl1PRB0MqNfC1iYlYgMzIBS+SfkOXMDvsfHRq7eoYMOtjFIAJFqJexjVwjJGuoTTJBHktFxleqqCouYKts9ylT6Yfzh3zsvDW2T8EHpRY2+Fny7h2uQBDffsEGC3X9iQ5/Hgto0mRwhfAtac/fvYLBn86Rgu9PDBWhsjJpQHEDpJJROufzALAJ96l/T3g8s2KT9vsXWcFmKmQ86z+4j637NpOFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8QUKkuIlfngvH1eOwyVv/DooDUyodoQgW94eLCdSfZg=;
 b=HeosD+V+wywuK0hT8U1BYUMwT/3TozNHZ+1dRTV01fWMMzfmScfcDWfKKO9IFxzfRnS8PqPH2ADxRNIiPnA8CRhAz74VKShCn4iEG1so/LxfNvRLLi9Y+V4otovrcGx1kD1nvhA8JBh3Abw7zjzqre2nffWH/DgJ7gh4ccK330I=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DM6PR12MB4089.namprd12.prod.outlook.com (2603:10b6:5:213::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Mon, 3 Oct
 2022 18:43:09 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8588:d2f4:2eb9:7021]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8588:d2f4:2eb9:7021%4]) with mapi id 15.20.5676.024; Mon, 3 Oct 2022
 18:43:08 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Borislav Petkov <bp@alien8.de>, Peter Gonda <pgonda@google.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "slp@redhat.com" <slp@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Subject: RE: [PATCH Part2 v6 13/49] crypto:ccp: Provide APIs to issue SEV-SNP
 commands
Thread-Topic: [PATCH Part2 v6 13/49] crypto:ccp: Provide APIs to issue SEV-SNP
 commands
Thread-Index: AQHY1dLd4Juks83jB0yfjCsoLH1Lj638u9DQgAAfqQCAAA0/0IAAC28AgAAEeoCAAARSgIAABIdQ
Date:   Mon, 3 Oct 2022 18:43:08 +0000
Message-ID: <SN6PR12MB2767CD108EBA7BE5D027330D8E5B9@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <a63de5e687c530849312099ee02007089b67e92f.1655761627.git.ashish.kalra@amd.com>
 <YzigaOHddWU706H5@zn.tnic>
 <SN6PR12MB2767062CAD241C0BAFB7FAD98E5B9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YzsK+szsWoAlMsrR@zn.tnic>
 <SN6PR12MB276753083B811B1055FDE6408E5B9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YzsfroL1/6D8rVTF@zn.tnic>
 <CAMkAt6pnqWWA8pc6uY5g1o076VLgjy1K1ZagDOgcuQfh=hnf3Q@mail.gmail.com>
 <YzsnB0Evh5NeRzOh@zn.tnic>
In-Reply-To: <YzsnB0Evh5NeRzOh@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-10-03T18:32:59Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=ab8ee364-c43b-47e8-b541-ae1e54bc083d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-10-03T18:43:06Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 988cc6e3-1ef2-4e52-9833-08f51d727390
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR12MB2767:EE_|DM6PR12MB4089:EE_
x-ms-office365-filtering-correlation-id: c6ed03d9-805a-4f4b-4c6c-08daa56f1de0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s8yssObdk6JlRjvrudJSDqBeQqTAOjKjY2dx30bma4OsdsG6xriOBsRUeBm/0Nkl48rrNVyTujR+M36npIPOzdGEgMC5p4Z62Sgsinauexu6lLei5L8yEg29Yt38wKjHvgwPAr3S1y3juGZziQoKx3e/f7fmmEtISkGq374dUdxTcaJLl3Xa8meyQeQ70skGxU7yeT4wWcampU3vTA88zs7bSKv22OFrWi75PmfNlFu7ZvNPsZ+f+fP63wVtNWDwnWpywzVl2JarsiQeC5bC5i7mlNyRZKZ+rj9niAHVb50qv1rIQtoRzwhdiHiCLVjjDjVQjtr5Aas2db9tebr5HilWunEx57lmMX2nfO9zLjk5psUWLNznqXJfY2gKpxQy9APNn6/9ng87cNg7HlTwRyxocdhts9h2aWfX35CSkIZjIEQmCmMOt4hfOLcc4Pr3rh7YcRiOAHtQ0RgcBJ+FR+NRecYzRFW5MyRYf4znTHP8+kfv49agh6Lve3FEFOZePiM59J+F4lrjGLg26wKGUQ2p6iBjspcPdOWSRiHfKGggX7QT0fS0V6wPiQbalQguWPYTb+nUtaGiYx15Cs4mnY5IiLnVz8QoGtvyWSNMqp5SS+IAGZvZY/OzOAMDiTmvp2j0KCzpIBVuWwsPTko2j9CkmMLeqPnyVTUCaXC2JtFmrMkwZOr4+2u7rVqtc443Kp/BJWBMUl/94HpvwixeJ3IOzSd4Doc7Ns/hIDIuNOXT20w8G+kjVTqUxjlalrHMuoc+7SqwBXwaB9910lOibg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(366004)(346002)(396003)(451199015)(6506007)(7696005)(110136005)(316002)(54906003)(66946007)(76116006)(4326008)(66476007)(55016003)(64756008)(66556008)(9686003)(26005)(33656002)(186003)(122000001)(38070700005)(2906002)(8936002)(5660300002)(7406005)(4744005)(38100700002)(66446008)(8676002)(86362001)(41300700001)(52536014)(7416002)(71200400001)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NTx374/TB85JviBC0mBAz/HQeAWV6X+Zdp/egWDFkfKSDpuNGhcyHKCx+yWw?=
 =?us-ascii?Q?Bi6zmqFF6X5vuZYLdq+1pFclfd3RFGTarKRRXkKOeN8ziPwsjX0Ux+d0fCtj?=
 =?us-ascii?Q?3g5hJ6cQJQlDiN2arVCgiSmS71M/07SVcqPVWnUTBjI2/qHv6BxnzSwo7n9O?=
 =?us-ascii?Q?urV6y3ejVTA+TO0rV4kkvqWH7WBWDtD9OXhAun6gZ1JWMusJbAsRZ8Qk4+J5?=
 =?us-ascii?Q?AbHXKMkbNAllDfLGGzeHjIxMy45Oud8GvExgroKbTT5VUnANPtSRsvVyoQrc?=
 =?us-ascii?Q?TZ1HmOf3/3KvldMMAy8EEPjU24Tg142FkE3Ls5yyf9v9esi6a3PLIPCexLxN?=
 =?us-ascii?Q?5BkPz5uQvDHkGhovjB2HzHFRUo1myvrOCpk4JLqUWybmLbPBERPy4vA6EtZS?=
 =?us-ascii?Q?Zz0hlBB9+KIg3fzXozgTQAlhwTEl6iMAcIduk3SbHweZV3fZ/MzX9TgWLzn3?=
 =?us-ascii?Q?ml6tfC1iqsIyLr1BjOfNJKfW0pKhmsyow7xkPDRJk+zXzXTBmdvsqRIzB4+k?=
 =?us-ascii?Q?Y1yC+Ir3L07+pDlVaMRCM8MZbraY5x17ou43RkKbVzSlncBtNKjLbgZfvMc1?=
 =?us-ascii?Q?nAOKqDI35xO2bRcbIZjpHbjjv7hJgD0h24bdj8nheFG6gdtIudW7/y2EtoNE?=
 =?us-ascii?Q?PG4MVSeYCUjELLqWgKol5APniDsbH6ulncbDS8afdrM+CTt2m8VEx7ynk11U?=
 =?us-ascii?Q?kSLoj2XLY6w0UMP7eusoie3UgzMnImAnDly2Qb0YGHKqHLzdwnD6KpL5uqFF?=
 =?us-ascii?Q?KGy9NZuTZoFr8wum+GFp1lJg/BMLHB19GAddHBhbSFvX5ftoroXZZjVzY0Gf?=
 =?us-ascii?Q?iyThzh6zwmEbdicZAh5UDv9lr5dN2pVE6kwSWb8NPW09UgTVApQQ5CS6ZfpR?=
 =?us-ascii?Q?2IL+3XcNVgidnlNbhndpH2G1Mlydl3k1wkoKcDd9xpEjT4BULQVg0Lg3wRpl?=
 =?us-ascii?Q?iUTybvZjXO+3AjrKtOODiERQXedJcDKdFFSP71bO7n8kS8mbOdoj/AyMed0S?=
 =?us-ascii?Q?kLTlPPg5cSB4u3ppdgI0oLz4bSbiyfVIuGzXQVg1gGIAmqizWRqUl0rp0eFM?=
 =?us-ascii?Q?x976Rb9rPygV2lOybq/XBdWq47IzhCUeJu8cT67IaGfJa+/tGSJfKAgtrvhG?=
 =?us-ascii?Q?pvewS5RBS6QEqUErfkmDYT4xqLVFxeroqPOG7hFzmOCDQpokl7FNvR8viI/i?=
 =?us-ascii?Q?E7WHajr68n+f94Z1K4LAxtubK/4t/lBPKqt6+FpTyGJdHvOClcol6w00CN5y?=
 =?us-ascii?Q?DBht4Xp2nxAilhhXtT4eAm9vw+dlxjnNf55emQ+D4ySJplx7c+JTl/6CqP+e?=
 =?us-ascii?Q?VSVBxio++dEDTC5EkTVwtIuvnJr95ggijmvGZzf7bPU48hwCOWcg/CVB0967?=
 =?us-ascii?Q?ljt5/ScU6/h3l/ns9I2fQPZ0Fa0mBYsN7n/R2I4Jf+zBQp3AL57+jAk14HxY?=
 =?us-ascii?Q?EUPlszymZ/uYQZA1Me1PyU/XlkEKkfvogriEs9ZpsieHhMVWqtkWPFtK4Faw?=
 =?us-ascii?Q?a3ePTJnfm+YNwoPQ6i1yA/om7gnJa6go/39dBxDp3lGUDcFAvQXPBcCxG2Ku?=
 =?us-ascii?Q?Ghxo9Xu8cbieE6ELg/E=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6ed03d9-805a-4f4b-4c6c-08daa56f1de0
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2022 18:43:08.6913
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: brjfDsa2jxjGGxMayICcsC4p7dXOMlvN04tBcmdZVQvYj2OS4gDJTd9+R8hTJxyXXZqquXbMIuvytr4COeGIZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4089
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Official Use Only - General]

>> We already have sev_issue_cmd_external_user() exported right?
>>=20
>> Another option could be to make these wrappers more helpful and less=20
>> silly.

>For example.

>My point is, whenever something needs to issue a SEV* fw command, somethin=
g adds a silly wrapper and this will become unwieldy pretty quickly.

>If a wrapper is not a dumb one but it actually does preparatory work befor=
e issuing the command so that the caller's life is made easy, then yes, by =
all means.

>If it is only plain forwarding a call to sev_do_cmd(), then I question the=
 whole point of the exercise...

Well, these all were added as APIs to serve as a abstraction for SEV/SNP gu=
est, and probably it is nice to have an abstracted interface, but I have no=
 issues
with replacing these simply with calls to sev_do_cmd().

Thanks,
Ashish
